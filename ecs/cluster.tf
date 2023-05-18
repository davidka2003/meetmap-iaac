locals {
  launch_type = "FARGATE"
  application_name = "main-prod-cluster"
}


resource "aws_ecs_cluster" "main" {
  name = local.application_name
}

