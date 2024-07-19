variable "parent_id" {
  description = "The parent ID of the resource"
}
variable "rest_api_id" {
  description = "The ID of the REST API"
}

variable "protocol_type" {
  description = "The type of connection"
  default     = "http://"
}

variable "votes_nlb_dns" {
  description = "The DNS name of the votes NLB"
}

variable "eurovota_votes_vpc_link" {
  description = "The VPC link for the votes NLB"
}

variable "authorizer_id" {
  description = "The ID of the authorizer"
}
