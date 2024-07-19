output "users_launch_template_id" {
  description = "The id of the users launch template."
  value       = aws_launch_template.users-launch-template-tf.id
    
}

output "votes_launch_template_id" {
  description = "The id of the votes launch template."
  value       = aws_launch_template.votes-launch-template-tf.id
    
}
