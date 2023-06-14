output "vpc_id" {
  description = "Vpc id"
  value       = aws_vpc.meetmap-vpc.id
}

output "public_subents_id" {
  description = "List of public subnets id"
  value       = aws_subnet.public_subnet[*].id
}

output "private_subents_id" {
  description = "List of private subnets id"
  value       = aws_subnet.private_subnet[*].id
}

output "public_sg_id" {
  description = "Public security group id"
  value       = aws_security_group.public_sg.id
}

output "private_sg_id" {
  description = "Private security group id"
  value       = aws_security_group.private_sg.id
}
