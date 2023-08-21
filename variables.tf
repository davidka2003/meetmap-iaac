#GCP vars
variable "gcp_svc_key" {
  type      = string
  sensitive = true
}


variable "gcp_project_id" {
  type = string
}


variable "gcp_region" {
  type = string
}

#AWS vars

variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}
