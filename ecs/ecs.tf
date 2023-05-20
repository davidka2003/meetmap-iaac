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

variable "vpc_id" {
  type = string
}

variable "alb_subents" {
  type = list(string)
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

resource "aws_cloudwatch_log_group" "log_group" {
  for_each = { for arg in var.arguments : arg.name => arg }
  name     = "/ecs/${each.value.name}"
  tags = {
    Environment = "production"
    Application = each.value.name
  }
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

resource "aws_security_group" "alb_sg" {

  name        = "alb-sg"
  description = "Allow inbound traffic from the Internet to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80 # Or 443 for HTTPS
    to_port     = 80 # Or 443 for HTTPS
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
//only one instance of alb there should be
resource "aws_lb" "alb" {
  name            = "alb"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.alb_subents
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_target_group" "tg" {
  for_each    = { for arg in var.arguments : arg.name => arg }
  name        = "${each.value.name}-tg"
  target_type = "ip"
  port        = each.value.containerPort # The port your service is listening on
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  health_check {
    enabled             = true
    interval            = 30
    path                = "/${each.value.name}" # change it to /health later
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 6
  }
}


resource "aws_lb_listener_rule" "lb_rule" {
  for_each     = { for arg in var.arguments : arg.name => arg }
  listener_arn = aws_lb_listener.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.value.name].arn

  }

  condition {
    path_pattern {
      values = ["/${each.value.name}*"]
    }
  }
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}
