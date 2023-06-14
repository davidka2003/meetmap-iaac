variable "arguments" {
  type = list(object({
    alb_dns_name           = string
    alb_zone_id            = string
    evaluate_target_health = bool
  }))
}

variable "domain_name" {
  type = string
}


variable "wildcard_domain" {
  type = string
}
