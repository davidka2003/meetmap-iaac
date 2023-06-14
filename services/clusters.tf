resource "aws_ecs_cluster" "main" {
  name = local.application_name
}

