output "pool_id" {
  description = "The id of the user pool"
  value       = aws_cognito_user_pool.users.id
}

output "pool_arn" {
  description = "The ARN of the user pool"
  value       = aws_cognito_user_pool.users.arn
}