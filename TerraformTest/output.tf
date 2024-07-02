output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "sg_id" {
  description = "The ID of the security group"
  value       = module.ec2.sg_id
}

output "ec2_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.ec2_id
}

output "elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = module.elb.elb_dns_name
}

output "cognito_user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = module.cognito.pool_id
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

