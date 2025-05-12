#Connect to Google Cloud Platform project
provider "google" {
  project = var.project_id
  region  = var.region
}


# Create a custom VPC (no default subnets)
resource "google_compute_network" "vpc_network" {
  name = "custom-vpc"
  auto_create_subnetworks = false
}

# Create a custom subnet inside that VPC
resource "google_compute_subnetwork" "subnet" {
  name          = "custom-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

#Allow internal traffic
resource "google_compute_firewall" "allow-internal" {
  name    = "allow-internal-traffic"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "all"
  }

  source_ranges = ["10.0.0.0/16"]
}
resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["8080", "3000"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}


# Create GCS bucket
resource "google_storage_bucket" "app_bucket" {
  name     = "${var.project_id}-bucket"
  location = var.region

}

#Create an SQL user
resource "google_sql_database_instance" "main" {
  name = "gallery-sql"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-n1-standard-1"

    #Set for only private connections
    ip_configuration {
      ipv4_enabled    = true
      authorized_networks {
        value = "0.0.0.0/0"
      }
    }
  }
}

#Create a SQL database
resource "google_sql_database" "gallery_db" {
  name = var.db_name
  instance = google_sql_database_instance.main.name
}

#Create an SQL user
resource "google_sql_user" "gallery_user" {
  name     = var.db_user
  instance = google_sql_database_instance.main.name
  password_wo = var.db_password
}

#Create a Compute Engine VM
resource "google_compute_instance" "gallery_vm" {
  name         = "gallery-vm"
  machine_type = "e2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {} # Required for external IP
  }

  tags = ["http-server"]

  service_account {
    email  = google_service_account.app_sa.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = file("startup.sh")

}


#Create a service account
resource "google_service_account" "app_sa" {
  account_id   = "node-app-sa"
  display_name = "Node.js App Service Account"
}

#SQL permissions
resource "google_project_iam_member" "sa_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

#Compute Engine permissions
resource "google_project_iam_member" "sa_logging_viewer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

#Upload files to bucket
resource "google_storage_bucket_iam_member" "sa_storage_uploader" {
  bucket = google_storage_bucket.app_bucket.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.app_sa.email}"
}




