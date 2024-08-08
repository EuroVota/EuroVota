output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "roel_name" {
  description = "The name of the IAM role"
  value = module.iam.role_name
}

output "cognito_user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = module.cognito.pool_id
}

output "users_ecr_repository_url" {
  description = "The URL of the users ECR repository"
  value = module.ecr.users_repository_url
}

output "votes_ecr_repository_url" {
  description = "The URL of the votes ECR repository"
  value = module.ecr.votes_repository_url
}

output "users_nlb_dns_name" {
  description = "The DNS name of users NLB"
  value       = module.elb.users_nlb_dns
}

output "votes_nlb_dns_name" {
  description = "The DNS name of votes NLB"
  value       = module.elb.votes_nlb_dns_name
}

output "kms_key" {
  description = "The KMS customer master key to encrypt state buckets."
  value       = module.remote_state.kms_key.key_id
}

output "state_bucket" {
  description = "The S3 bucket to store the remote state file."
  value       = module.remote_state.state_bucket.bucket
}

output "dynamodb_table" {
  description = "The DynamoDB table used to store the lock"
  value       = module.remote_state.dynamodb_table.id
}

output "dynamic_table_name" {
  description = "The name of the DynamoDB table"
  value = module.dynamodb.dynamodb_table_name
}

output "api_gateway_stage_url" {
  description = "The url of the API Gateway stage"
  value       = module.api_gateway.api_gateway_stage_url
}


