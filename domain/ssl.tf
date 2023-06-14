resource "aws_acm_certificate" "certificate" {
  domain_name       = var.wildcard_domain # Update with your domain/subdomain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_acm_certificate_validation" "validation" {
#   certificate_arn         = aws_acm_certificate.certificate.arn
#   validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]
# }

resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id = aws_route53_zone.zone.id # Update with your Route 53 zone ID
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}
