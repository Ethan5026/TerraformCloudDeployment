output "vpc_name" {
  description = "The name of the custom VPC"
  value       = google_compute_network.vpc_network.name
}

output "vpc_self_link" {
  description = "Self-link to the VPC"
  value       = google_compute_network.vpc_network.self_link
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_ip_range" {
  description = "The IP CIDR range of the subnet"
  value       = google_compute_subnetwork.subnet.ip_cidr_range
}

output "firewall_internal_rule_name" {
  description = "The name of the firewall rule allowing internal traffic"
  value       = google_compute_firewall.allow-internal.name
}

output "firewall_http_rule_name" {
  description = "The name of the firewall rule allowing https traffic"
  value       = google_compute_firewall.allow-http.name
}

output "firewall_allowed_internal_protocols_ports" {
  description = "Allowed internal protocols and ports for the firewall"
  value       = google_compute_firewall.allow-internal.allow
}

output "firewall_allowed_external_protocols_ports" {
  description = "Allowed external protocols and ports for the firewall"
  value       = google_compute_firewall.allow-http.allow
}

output "bucket_name" {
  description = "The name of the GCP bucket"
  value = google_storage_bucket.app_bucket.name
}

output "sql_connection_name" {
  description = "The name of the SQL instance"
  value = google_sql_database_instance.main.connection_name
}
output "sql_address" {
  description = "The IP address information for the SQL instance"
  value = google_sql_database_instance.main.ip_address
}

output "sql_database_name" {
  description = "The name of the SQL database"
  value = google_sql_database.gallery_db.name
}

output "sql_user_name"{
  description = "The username for the SQL user"
  value = google_sql_user.gallery_user.name
}

output "sql_user_password" {
  description = "The password for the SQL user"
  value = google_sql_user.gallery_user.password
  sensitive = true
}

output "compute_instance_name" {
  description = "The name of the Compute Engine VM"
  value       = google_compute_instance.gallery_vm.name
}

output "node_app_url_port_80" {
  description = "Public URL to access the Node.js app on port 80"
  value = try(google_compute_instance.gallery_vm.network_interface[0].access_config[0].nat_ip, "VM does not have an external IP")
}

output "service_account_email" {
  description = "The email address of the service account used by the Node.js app"
  value       = google_service_account.app_sa.email
}

output "service_account_roles" {
  description = "IAM roles granted to the service account"
  value = [
    google_storage_bucket_iam_member.sa_storage_uploader.role,
    google_project_iam_member.sa_cloudsql_client.role,
    google_project_iam_member.sa_logging_viewer.role
  ]
}
