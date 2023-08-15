resource "aws_acm_certificate" "vpn_server_certificate" {
  domain_name       = var.vpn_domain_name # Update with your domain/subdomain
  validation_method = "DNS"
  tags = {
    Name = "Meetmap ClientVPN"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "zone" {
  #   for_each = { for arg in var.arguments : arg.name => arg }
  name = var.vpn_domain_name # Update with your domain name
}


resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.vpn_server_certificate.domain_validation_options : dvo.domain_name => {
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


resource "aws_acm_certificate" "vpn_server_client_root_cert" {
  # private_key      = file("../certificates/client-root/private-key.key")
  certificate_body = file("pki/easyrsa3/pki/ca.crt")
  private_key      = file("pki/easyrsa3/pki/private/ca.key")
  tags = {
    Name = "Meetmap ClientVPN-Root-Cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}
