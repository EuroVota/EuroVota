output "pool_id" {
  description = "The id of the user pool"
  value       = aws_cognito_user_pool.users2.id
}