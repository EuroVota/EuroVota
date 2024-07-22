# variable "users_nlb_arn" {
#   description = "The ARN of the users NLB"
# }

# variable "users_nlb_dns" {
#     description = "The DNS name of the users NLB"
# }

# variable "votes_nlb_arn" {
#   description = "The ARN of the votes NLB"
# }

# variable "votes_nlb_dns" {
#   description = "The DNS name of the votes NLB"
# }

variable "nlb_arn" {
  description = "The ARN of the NLB"
}

variable "nlb_dns" {
    description = "The DNS name of the NLB"
}

variable "protocol_type" {
  description = "The type of connection"
  default = "http://"
}

variable "user_pool_arn" {
    description = "The ARN of the user pool"
}

