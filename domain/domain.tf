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


resource "aws_route53_zone" "zone" {
  #   for_each = { for arg in var.arguments : arg.name => arg }
  name = var.domain_name # Update with your domain name
}

resource "aws_route53_record" "example_record" {
  for_each = { for arg in var.arguments : arg.name => arg }
  zone_id  = aws_route53_zone.zone.zone_id
  name     = var.domain_name # Update with your domain name
  type     = "A"

  alias {
    name                   = each.value.alb_dns_name
    zone_id                = each.value.alb_zone_id
    evaluate_target_health = false
  }
}
