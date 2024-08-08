variable "vpc_id" {
    description = "The VPC ID where the EKS cluster will be deployed"
}

variable "role_arn" {
    description = "The ARN of the IAM role to be used by the EKS cluster"
}

variable "public_subnets_ids" {
    description = "The public subnet A ID"
}

variable "private_subnets_ids" {
    description = "The private subnets IDs"
}
