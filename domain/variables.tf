variable "arguments" {
  type = list(object({
    dns_name               = string
    zone_id                = string
    evaluate_target_health = bool
  }))
}

variable "domain_name" {
  type = string
}


variable "wildcard_domain" {
  type = string
}
