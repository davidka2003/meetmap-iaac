resource "aws_security_group" "vpn_sg" {
  name        = "vpn-sg"
  vpc_id      = var.vpc_id
  description = "Allow inbound traffic from port 443, to the VPN"

  ingress {
    from_port   = 443
    protocol    = "UDP"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Incoming VPN connection"
  }

  ingress {
    from_port   = 1194
    protocol    = "UDP"
    to_port     = 1194
    cidr_blocks = ["0.0.0.0/0"]
    description = "Incoming VPN connection"
  }

  ingress {
    from_port   = 443
    protocol    = "TCP"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Incoming VPN connection"
  }

  ingress {
    from_port   = 1194
    protocol    = "TCP"
    to_port     = 1194
    cidr_blocks = ["0.0.0.0/0"]
    description = "Incoming VPN connection"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
