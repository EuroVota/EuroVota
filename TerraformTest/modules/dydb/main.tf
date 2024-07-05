provider "aws" {
  region = var.region
}

resource "aws_dynamodb_table" "EurovisionVotes" {
  name           = "EurovisionVotes"
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "UserID"
  range_key      = "VoteID"

  attribute {
    name = "UserID"
    type = "S"
  }

  attribute {
    name = "VoteID"
    type = "S"
  }

  attribute {
    name = "CountryVoted"
    type = "S"
  }

  attribute {
    name = "VoteValue"
    type = "N"
  }

  global_secondary_index {
    name               = "VotesByCountry"
    hash_key           = "CountryVoted"
    projection_type    = "ALL"
    read_capacity      = var.read_capacity
    write_capacity     = var.write_capacity
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
}

resource "aws_dynamodb_table" "CountryRanking" {
  name           = "CountryRanking"
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "CountryCode"

  attribute {
    name = "CountryCode"
    type = "S"
  }

  attribute {
    name = "CountryName"
    type = "S"
  }

  attribute {
    name = "VoteCount"
    type = "N"
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
}

# Auto Scaling for EurovisionVotes Table
resource "aws_appautoscaling_target" "votes_read_target" {
  max_capacity       = var.max_read_capacity
  min_capacity       = var.min_read_capacity
  resource_id        = "table/EurovisionVotes"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "votes_write_target" {
  max_capacity       = var.max_write_capacity
  min_capacity       = var.min_write_capacity
  resource_id        = "table/EurovisionVotes"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "votes_read_policy" {
  name               = "VoteTableReadScalingPolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.votes_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.votes_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.votes_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.target_utilization

    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "votes_write_policy" {
  name               = "VoteTableWriteScalingPolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.votes_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.votes_write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.votes_write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.target_utilization

    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
  }
}

# Auto Scaling for CountryRanking Table
resource "aws_appautoscaling_target" "ranking_read_target" {
  max_capacity       = var.max_read_capacity
  min_capacity       = var.min_read_capacity
  resource_id        = "table/CountryRanking"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "ranking_write_target" {
  max_capacity       = var.max_write_capacity
  min_capacity       = var.min_write_capacity
  resource_id        = "table/CountryRanking"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "ranking_read_policy" {
  name               = "RankingTableReadScalingPolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ranking_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ranking_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ranking_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.target_utilization

    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "ranking_write_policy" {
  name               = "RankingTableWriteScalingPolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ranking_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ranking_write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ranking_write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.target_utilization

    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
  }
}