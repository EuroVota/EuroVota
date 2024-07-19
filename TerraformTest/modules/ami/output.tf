output "ami_arn" {
  description = "The arn of the ami."
  value       = aws_ami_from_instance.users_ami_tf.arn
}

output "ami_id" {
  description = "The id of the ami."
  value       = aws_ami_from_instance.users_ami_tf.id
}
