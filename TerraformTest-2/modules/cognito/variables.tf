variable "prefix" {
  description = "Prefix of the name of the created resources"
  type        = string
  default     = "my"
}
variable "suffix" {
  description = "Suffix of the name of the created resources"
  type        = string
  default     = "tf"
}
variable "role_arn" {
    description = "The ARN of the IAM role"
}