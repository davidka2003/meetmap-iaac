resource "aws_security_group" "alb_sg" {

  name        = "alb-sg"
  description = "Allow inbound traffic from the Internet to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 443
    to_port     = 443
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

//only one instance of alb there should be
resource "aws_lb" "alb" {
  name            = "alb"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.alb_subents
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  certificate_arn = var.certificate_arn # Replace with the ARN of your ACM SSL certificate

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
    path                = "/${each.value.prefix}" # change it to /health later
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 6
  }
}


resource "aws_lb_listener_rule" "lb_rule" {
  for_each     = { for arg in var.arguments : arg.name => arg }
  listener_arn = aws_lb_listener.https_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.value.name].arn

  }

  condition {
    path_pattern {
      values = ["/${each.value.prefix}*"]
    }
  }
}
