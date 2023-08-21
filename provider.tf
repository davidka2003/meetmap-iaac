# AWS provider
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region

}

# GCP provider
provider "google" {
  project     = var.gcp_project_id
  credentials = file(var.gcp_svc_key)
  region      = var.gcp_region
}
