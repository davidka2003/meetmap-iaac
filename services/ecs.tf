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
    security_groups  = [aws_security_group.ecs_sg[each.value.name].id]
    subnets          = each.value.subnets
  }
  //now target group will know to what ecs forward the traffic
  load_balancer {
    target_group_arn = aws_lb_target_group.tg[each.value.name].arn
    container_name   = each.value.name
    container_port   = each.value.containerPort
  }
  depends_on = [aws_ecr_repository.repository, aws_ecs_task_definition.this]
}

resource "aws_ecs_task_definition" "this" {
  for_each = { for arg in var.arguments : arg.name => arg }

  family                   = each.value.name
  requires_compatibilities = [local.launch_type]

  container_definitions = jsonencode([
    {
      name  = each.value.name
      image = aws_ecr_repository.repository[each.value.name].repository_url
      # cpu       = 512
      # memory    = 1024
      essential = true
      portMappings = [
        {
          name          = each.value.name
          containerPort = each.value.containerPort
          hostPort      = each.value.containerPort
          appProtocol   = "http"
          protocol      = "tcp"
        }
      ]
      environment = each.value.env_vars
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${each.value.name}"
          awslogs-create-group  = "true"
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    },
  ])
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  cpu                = "256"
  memory             = "512"
  network_mode       = "awsvpc"
}

resource "aws_security_group" "ecs_sg" {
  for_each    = { for arg in var.arguments : arg.name => arg }
  name        = "${each.value.name}-sg"
  description = "Allow inbound traffic from the ALB to the ${each.value.name} service"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = each.value.containerPort # The port your service is listening on
    to_port         = each.value.containerPort
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Allow traffic from the ALB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
