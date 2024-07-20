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

variable "vpc_id" {
  description = "The id of the VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "the ip of the public subnet"
  type        = string
}

variable "private_subnets_ids" {
  description = "The id of the subnet"
  type        = list(string)
}