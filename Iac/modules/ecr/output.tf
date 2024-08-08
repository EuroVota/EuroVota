output "users_repository_url" {
  description = "The URL of the users ECR repository"
  value = aws_ecr_repository.users.repository_url
}

output "votes_repository_url" {
  description = "The URL of the votes ECR repository"
  value = aws_ecr_repository.votes.repository_url
}