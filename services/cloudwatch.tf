
resource "aws_cloudwatch_log_group" "log_group" {
  for_each = { for arg in var.arguments : arg.name => arg }
  name     = "/ecs/${each.value.name}"
  tags = {
    Environment = "production"
    Application = each.value.name
  }
}
