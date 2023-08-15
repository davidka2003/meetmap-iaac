resource "random_password" "password" {
  length  = 32
  special = true
}

resource "aws_ssm_parameter" "opensearch_master_user" {
  name        = "/service/${var.domain}/MASTER_USER"
  description = "opensearch_password for ${var.domain} domain"
  type        = "SecureString"
  value       = "${local.master_user},${random_password.password.result}"
}
