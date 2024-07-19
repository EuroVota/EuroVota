output "sg_id" {
  description = "The id of the security group."
  value       = aws_security_group.users-tf-sg.id
}

/*output "users_ec2_id" {
  description = "The id of the security group."
  value       = aws_instance.users-tf.id
}*/

output "votes_launch_template_id" {
  description = "The id of the votes launch template."
  value = aws_launch_template.votes-launch-template.id
}

