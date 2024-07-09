resource "aws_dynamodb_table" "eurovision_votes" {
  name           = "EurovisionVotes"
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "userId"
  range_key      = "voteId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "voteId"
    type = "S"
  }

  attribute {
    name = "country"
    type = "S"
  }

  attribute {
    name = "voteValue"
    type = "N"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  global_secondary_index {
    name               = "country-voteValue-index"
    hash_key           = "country"
    range_key          = "voteValue"
    read_capacity      = var.read_capacity
    write_capacity     = var.write_capacity
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "userId-timestamp-index"
    hash_key           = "userId"
    range_key          = "timestamp"
    read_capacity      = var.read_capacity
    write_capacity     = var.write_capacity
    projection_type    = "ALL"
  }

  tags = {
    Name        = "EurovisionVotes"
    Environment = "Production"
  }
}

resource "aws_appautoscaling_target" "read_target" {
  max_capacity       = var.autoscaling_max_read_capacity
  min_capacity       = var.autoscaling_min_read_capacity
  resource_id        = "table/${aws_dynamodb_table.eurovision_votes.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "write_target" {
  max_capacity       = var.autoscaling_max_write_capacity
  min_capacity       = var.autoscaling_min_write_capacity
  resource_id        = "table/${aws_dynamodb_table.eurovision_votes.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read_policy" {
  name                   = "DynamoDBReadAutoScalingPolicy"
  policy_type            = "TargetTrackingScaling"
  resource_id            = aws_appautoscaling_target.read_target.resource_id
  scalable_dimension     = aws_appautoscaling_target.read_target.scalable_dimension
  service_namespace      = aws_appautoscaling_target.read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "write_policy" {
  name                   = "DynamoDBWriteAutoScalingPolicy"
  policy_type            = "TargetTrackingScaling"
  resource_id            = aws_appautoscaling_target.write_target.resource_id
  scalable_dimension     = aws_appautoscaling_target.write_target.scalable_dimension
  service_namespace      = aws_appautoscaling_target.write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}