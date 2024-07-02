output "sg_id" {
  description = "The id of the security group."
  value       = aws_security_group.users-tf-sg.id
}

output "ec2_id" {
  description = "The id of the security group."
  value       = aws_instance.users-tf.id
}

