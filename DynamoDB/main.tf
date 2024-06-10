provider "aws" {
  region = "us-east-1"
}

variable "read_capacity" {
  default = 5
}

variable "write_capacity" {
  default = 5
}

resource "aws_dynamodb_table" "eurovision_votes" {
  name           = "EurovisionVotes"
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "country"
  range_key      = "userId"

  attribute {
    name = "country"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

    # Índice Secundario Global (GSI)
  global_secondary_index {
    name               = "userId-country-index"
    hash_key           = "userId"
    range_key          = "country"
    read_capacity      = var.read_capacity
    write_capacity     = var.write_capacity
    projection_type    = "ALL"
  }

  tags = {
    Name        = "EurovisionVotes"
    Environment = "Production"
  }
}
