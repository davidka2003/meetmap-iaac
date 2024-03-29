resource "aws_route53_zone" "zone" {
  #   for_each = { for arg in var.arguments : arg.name => arg }
  name = var.domain_name # Update with your domain name
}

resource "aws_route53_record" "example_record" {
  for_each = { for arg in var.arguments : arg.dns_name => arg }
  zone_id  = aws_route53_zone.zone.zone_id
  name     = var.domain_name # Update with your domain name
  type     = "A"

  alias {
    name                   = each.value.dns_name
    zone_id                = each.value.zone_id
    evaluate_target_health = false
  }
}
