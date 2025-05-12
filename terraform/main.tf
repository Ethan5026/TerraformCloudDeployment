provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Create GCS bucket
resource "google_storage_bucket" "app_bucket" {
  name     = "${var.project_id}-bucket"
  location = var.region
}

# Create Cloud SQL
resource "google_sql_database_instance" "db_instance" {
  name             = "nodejs-sql-instance"
  database_version = "POSTGRES_13"  # or MYSQL_8_0
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
    }
  }
}

resource "google_sql_user" "users" {
  name     = var.db_user
  instance = google_sql_database_instance.db_instance.name
  password = var.db_password
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.db_instance.name
}

# Create Compute Engine VM
resource "google_compute_instance" "node_instance" {
  name         = "node-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = file("startup.sh")

  tags = ["http-server"]

  metadata = {
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
    DB_NAME     = var.db_name
    DB_HOST     = google_sql_database_instance.db_instance.connection_name
  }
}

resource "google_compute_firewall" "default" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}
