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

variable "vpc-cidr" {
  description = "The address range of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}