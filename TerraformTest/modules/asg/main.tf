data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_autoscaling_group" "auto_scaling_group_users_tf" {
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [for i in var.private_subnets_ids[*] : i]
  target_group_arns = [var.users_tg_arn]

  max_instance_lifetime = 60 * 60 * 24 * 7

  capacity_rebalance = true

  mixed_instances_policy {

    instances_distribution {
      // prioritized, lowest-price
      on_demand_allocation_strategy = "prioritized"
      // Minimum number of on-demand/reserved nodes
      on_demand_base_capacity = 1
      // Once that minimum has been granted, percentage of on-demand for
      // the rest of the total capacity
      on_demand_percentage_above_base_capacity = 25
      // lowest-price, capacity-optimized, capacity-optimized-prioritized, price-capacity-optimized
      spot_allocation_strategy = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = var.users_launch_template_id
        version = "$Latest"
      }

      override {
        instance_type     = "t4g.micro"
        weighted_capacity = "1"
      }

      override {
        instance_type     = "t4g.small"
        weighted_capacity = "2"
      }

      override {
        instance_type     = "t4g.medium"
        weighted_capacity = "2"
      }
    }
  }
}

resource "aws_autoscaling_group" "auto_scaling_group_votes_tf" {
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [for i in var.private_subnets_ids[*] : i]
  target_group_arns = [var.votes_tg_arn]

  max_instance_lifetime = 60 * 60 * 24 * 7

  capacity_rebalance = true

  mixed_instances_policy {

    instances_distribution {
      // prioritized, lowest-price
      on_demand_allocation_strategy = "prioritized"
      // Minimum number of on-demand/reserved nodes
      on_demand_base_capacity = 1
      // Once that minimum has been granted, percentage of on-demand for
      // the rest of the total capacity
      on_demand_percentage_above_base_capacity = 25
      // lowest-price, capacity-optimized, capacity-optimized-prioritized, price-capacity-optimized
      spot_allocation_strategy = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = var.votes_launch_template_id
        version = "$Latest"
      }

      override {
        instance_type     = "t4g.micro"
        weighted_capacity = "1"
      }

      override {
        instance_type     = "t4g.small"
        weighted_capacity = "2"
      }

      override {
        instance_type     = "t4g.medium"
        weighted_capacity = "2"
      }
    }
  }
}


resource "aws_autoscaling_schedule" "users_scale_up" {
  scheduled_action_name  = "users_scale_up"
  min_size               = 3
  max_size               = 30
  desired_capacity       = 3
  start_time             = "2024-07-24T19:00:00Z"
  end_time               = "2024-07-24T22:00:00Z"
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group_users_tf.name
}

resource "aws_autoscaling_schedule" "votes_scale_up" {
  scheduled_action_name  = "votes_scale_up"
  min_size               = 3
  max_size               = 30
  desired_capacity       = 3
  start_time             = "2024-07-24T20:47:00Z"
  end_time               = "2024-07-24T23:00:00Z"
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group_votes_tf.name
}

