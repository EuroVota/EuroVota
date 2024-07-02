variable "my-ip" {
  description = "Personal IP address"
  type        = string
  default     = "85.57.39.131/32"
}
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
variable "instance_profile_name" {
  description = "The name of the instance profile"
  type        = string
}
variable "public_subnet_ip" {
  description = "the ip of the public subnet"
  type        = string
}
variable "private_subnets_ids" {
  description = "The id of the subnet"
  type        = list(string)
}
variable "elb_security_group_id" {
  description = "The id of elb security group"
  type        = string
}