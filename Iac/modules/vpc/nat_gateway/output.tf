output "vpc_id" {
  description = "The id of the NAT Gateway"
  value       = aws_nat_gateway.user_nat_gateway.id
}
