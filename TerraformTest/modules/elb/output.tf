output "users_tg_arn" {
  description = "The ARN of the users target group."
  value       = aws_lb_target_group.users-tg2.arn
}

output "users_nlb_arn" {
  description = "The ARN of the users NLB"
  value = aws_lb.users-lb.arn
}

output "users_dns_name" {
  description = "The DNS name of the users NLB"
  value       = aws_lb.users-lb.dns_name
}

output "votes_tg_arn" {
  description = "The ARN of the votes target group."
  value       = aws_lb_target_group.votes-tg2.arn
}

output "votes_nlb_arn" {
  description = "The ARN of the votes NLB"
  value = aws_lb.votes-lb.arn
}

output "votes_dns_name" {
  description = "The DNS name of the votes NLB"
  value       = aws_lb.votes-lb.dns_name
}


output "elb_id" {
  description = "The ARN of the ELB"
  value       = aws_lb.users-lb.id
}

output "elb_security_group_id" {
  description = "The ID of the security group of the ELB"
  value       = aws_security_group.euro-vota-sg.id
}

