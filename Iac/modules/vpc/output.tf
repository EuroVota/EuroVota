output "vpc_id" {
  description = "The id of the VPC."
  value       = aws_vpc.vpc_tf.id
}

output "public_subnet_id" {
  description = "The id of the public subnet."
  value       = aws_subnet.public.id
}

output "private_subnets_ids" {
  description = "The ids of the privates subnets."
  value       = aws_subnet.private[*].id
}