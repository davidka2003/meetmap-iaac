variable "domain" {
  type = string
}

variable "engine_version" {
  type    = string
  default = "2.7"
}

variable "instance_type" {
  type    = string
  default = "t3.micro.search"
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "custom_domain" {
  type    = string
  default = "opensearch.meetmap.xyz"
}

variable "custom_domain_certificate_arn" {
  type = string
}

variable "ebs_volume_size" {
  type    = number
  default = 10
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

# variable "dedicated_master_count" {
#   type = number
#   default = 3
# }

# variable "dedicated_master_type" {
#   type = string
# }

# variable "dedicated_master_enabled" {
#   type = bool
#   default = false
# }

variable "zone_awareness_enabled" {
  type    = bool
  default = false
}

variable "volume_type" {
  type    = string
  default = "gp2"
}


locals {
  master_user = "${var.domain}-masteruser"
}
