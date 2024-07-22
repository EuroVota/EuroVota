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

# variable "ami_id" {
#   description = "The id of the ami"
#   type        = string
# }

variable "users_sg_id" {
  description = "The id of the users security group"
  type        = string
}

variable "votes_sg_id" {
  description = "The id of the users security group"
  type        = string
}

variable "instance_profile_name" {
  description = "The name of the instance profile"
  type        = string
}
