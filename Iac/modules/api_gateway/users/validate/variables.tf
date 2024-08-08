variable "parent_id" {
  description = "The parent ID of the resource"
}

variable "resource_id" {
  description = "The ID of the resource"
}

variable "resource_path" {
  description = "The path of the resource"
}

variable "rest_api_id" {
  description = "The ID of the REST API"
}

variable "protocol_type" {
  description = "The type of connection"
  default     = "http://"
}

variable "users_nlb_dns" {
  description = "The DNS name of the users NLB"
}

variable "eurovota_users_vpc_link" {
  description = "The VPC link for the users NLB"
}
