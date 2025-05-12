variable "project_id" {}
variable "region" {
  default = "us-central1"
}
variable "zone" {
  default = "us-central1-a"
}
variable "db_user" {
  default = "nodeuser"
}
variable "db_password" {}
variable "db_name" {
  default = "nodedb"
}
