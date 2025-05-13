resource "google_app_engine_application" "app" {
  project     = "final-459618"
  location_id = "us-central"
}


resource "null_resource" "deploy_node_app" {
  depends_on = [google_app_engine_application.app]

  provisioner "local-exec" {
    command = "powershell.exe -ExecutionPolicy Bypass -File ../deploy.ps1 > ../deploy.log 2>&1"
  }

}
