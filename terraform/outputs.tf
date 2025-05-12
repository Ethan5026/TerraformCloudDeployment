output "bucket_name" {
  value = google_storage_bucket.app_bucket.name
}

output "vm_ip" {
  value = google_compute_instance.node_instance.network_interface[0].access_config[0].nat_ip
}
