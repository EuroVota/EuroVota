data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_autoscaling_group" "auto_scaling_group_users_tf" {
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [for i in var.private_subnets_ids[*] : i]
  target_group_arns = [var.users_tg_arn]

  launch_template {
    id      = var.users_launch_template_id
    version = "$Latest"
  }
}


resource "aws_autoscaling_group" "auto_scaling_group_votes_tf" {
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [for i in var.private_subnets_ids[*] : i]
  target_group_arns = [var.votes_tg_arn]

  launch_template {
    id      = var.votes_launch_template_id
    version = "$Latest"
  }
}

