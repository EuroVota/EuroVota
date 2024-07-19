variable "private_subnets_ids" {
  description = "The id of the subnet"
  type        = list(string)
}

variable "users_launch_template_id" {
  description = "The id of the users launch template."
  type        = string
}

variable "votes_launch_template_id" {
  description = "The id of the votes launch template."
  type        = string
}

# variable "elb_id" {
#   description = "The id of the elb."
#   type        = string
# }

variable "users_tg_arn" {
  description = "The arn of the users target group."
  type        = string
}

variable "votes_tg_arn" {
  description = "The arn of the votes target group."
  type        = string
}
