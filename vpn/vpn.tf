resource "aws_ec2_client_vpn_endpoint" "public" {
  description            = "Client VPN public"
  server_certificate_arn = aws_acm_certificate.vpn_server_certificate.arn
  client_cidr_block      = "10.0.0.0/22" # Modify as per your CIDR block requirement

  security_group_ids = [aws_security_group.vpn_sg.id]
  vpc_id             = var.vpc_id
  authentication_options {
    type = "certificate-authentication"

    root_certificate_chain_arn = aws_acm_certificate.vpn_server_client_root_cert.arn
  }

  split_tunnel = true

  connection_log_options {
    enabled              = true
    cloudwatch_log_group = aws_cloudwatch_log_group.clientvpn_log_group.name
  }

  transport_protocol = "udp"
  # dns_servers        = ["AmazonProvidedDNS"]

  #   target_network_cidr {
  #     client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.example.id
  #     target_network_cidr    = "10.0.0.0/16" # Modify to a CIDR block in your VPC
  #   }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    # aws_acm_certificate.vpn_server_certificate,
    aws_acm_certificate.vpn_server_client_root_cert
  ]
}

resource "aws_ec2_client_vpn_network_association" "public" {
  for_each               = { for i, arg in var.subnet_ids : tostring(i) => arg }
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.public.id
  subnet_id              = each.value # Make sure to declare this variable or replace with actual subnet ID
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.public.id
  target_network_cidr    = var.vpc_cidr
  authorize_all_groups   = true
}
# output "client_vpn_endpoint_id" {
#   value = aws_ec2_client_vpn_endpoint.public.id
# }
