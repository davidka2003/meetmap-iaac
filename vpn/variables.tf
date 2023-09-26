variable "vpn_domain_name" {
  type = string
}


variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the Client VPN should be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids to which u wanna target vpn"
}

variable "vpc_cidr" {
  type        = string
  description = "Vpc cidr block"
}
