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
variable "instance_id" {
  description = "The id of the instance to attach to the ELB"
  type        = string
}
variable "private_subnets_ids" {
  description = "List of private subnets ids"
  type        = list(string)
}