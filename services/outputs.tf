
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "aws_alb" {
  description = "aws alb"
  value       = aws_lb.alb
}
