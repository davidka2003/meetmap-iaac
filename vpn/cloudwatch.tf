resource "aws_cloudwatch_log_group" "clientvpn_log_group" {
  name              = "meetmap-clientvpn-connection-logs"
  retention_in_days = 14 # Retain logs for 14 days; adjust as needed
}
