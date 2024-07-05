variable "read_capacity" {
  description = "The initial read capacity units for the DynamoDB table"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "The initial write capacity units for the DynamoDB table"
  type        = number
  default     = 5
}

variable "max_read_capacity" {
  description = "The maximum read capacity units for the DynamoDB table"
  type        = number
  default     = 100
}

variable "max_write_capacity" {
  description = "The maximum write capacity units for the DynamoDB table"
  type        = number
  default     = 100
}

variable "min_read_capacity" {
  description = "The minimum read capacity units for the DynamoDB table"
  type        = number
  default     = 5
}

variable "min_write_capacity" {
  description = "The minimum write capacity units for the DynamoDB table"
  type        = number
  default     = 5
}

variable "target_utilization" {
  description = "The target utilization percentage for DynamoDB Auto Scaling"
  type        = number
  default     = 70
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-west-2"
}