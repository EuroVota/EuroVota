output "users_sg_id" {
  description = "The id of the users security group."
  value       = aws_security_group.users-tf-sg.id
}

output "votes_sg_id" {
  description = "The id of the votes security group."
  value       = aws_security_group.votes-tf-sg.id
}

# output "ec2_id" {
#   description = "The id of the instance."
#   value       = aws_instance.users-tf.id
# }

