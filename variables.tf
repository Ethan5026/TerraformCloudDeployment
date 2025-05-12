variable "project_id" {
  default = "final-459618"
}
variable "region" {
  default = "us-central1"
}
variable "zone" {
  default = "us-central1-a"
}
variable "db_user" {
  default = "nodeuser"
}
variable "db_password" {
  default = "nodepassword"
  sensitive = true
}
variable "db_name" {
  default = "nodedb"
}
