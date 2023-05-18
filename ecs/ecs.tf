variable "arguments" {
  type = list(object({
    name            = string
    subnets         = list(string)
    security_groups = list(string)
    replicas        = number
    containerPort   = number
    publicIp        = bool
    env_vars = list(object({
      name  = string
      value = string
    }))
  }))
}


resource "aws_ecr_repository" "repository" {
  for_each = { for arg in var.arguments : arg.name => arg }

  name                 = "meetmap-${each.value.name}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "policy" {
  for_each   = aws_ecr_repository.repository
  repository = each.value.name
  policy     = data.aws_iam_policy_document.ecr-allow-push-pull-policy.json
}

resource "aws_ecs_task_definition" "this" {
  for_each = { for arg in var.arguments : arg.name => arg }

  family                   = each.value.name
  requires_compatibilities = [local.launch_type]

  container_definitions = jsonencode([
    {
      name      = each.value.name
      image     = aws_ecr_repository.repository[each.value.name].repository_url
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = each.value.containerPort
          hostPort      = each.value.containerPort
        }
      ]
      environment = each.value.env_vars
    },
  ])
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  cpu                = "256"
  memory             = "512"
  network_mode       = "awsvpc"
}

resource "aws_ecs_service" "this" {
  for_each = { for arg in var.arguments : arg.name => arg }

  name                               = each.value.name
  cluster                            = aws_ecs_cluster.main.id
  desired_count                      = each.value.replicas
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0
  launch_type                        = local.launch_type
  task_definition                    = aws_ecs_task_definition.this[each.value.name].arn

  network_configuration {
    assign_public_ip = each.value.publicIp ? true : false
    security_groups  = each.value.security_groups
    subnets          = each.value.subnets
  }
}
