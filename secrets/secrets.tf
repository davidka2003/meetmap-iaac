data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "meetmap-backend-secrets"
}

output "secrets" {
  value = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}
