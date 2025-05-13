terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.79.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }
  }
}