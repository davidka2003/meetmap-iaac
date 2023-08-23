variable "arguments" {
  type = list(object({
    prefix  = string
    name    = string
    subnets = list(string)
    # security_groups = list(string)
    replicas      = number
    containerPort = number
    publicIp      = bool

    cpu    = optional(string, "256")
    memory = optional(string, "512")

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

variable "is_https" {
  type = bool
}

variable "certificate_arn" {
  type        = string
  description = "Certificate Arn for ALB"
}

locals {
  launch_type      = "FARGATE"
  application_name = "main-prod-cluster"
}
