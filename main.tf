terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.67"
    }
  }
}

# module "maps" {
#   source            = "./maps"
#   gcp_project_id    = var.gcp_project_id
#   maps_api_key_name = "meetmap-maps-backend-api-key"
# }

module "budget" {
  source = "./budget"
}

module "users" {
  source = "./users"
}

