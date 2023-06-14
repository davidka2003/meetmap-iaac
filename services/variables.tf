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

locals {
  launch_type      = "FARGATE"
  application_name = "main-prod-cluster"
}
