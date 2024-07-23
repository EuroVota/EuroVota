resource "aws_api_gateway_resource" "eurovota_api_votes" {
  parent_id   = var.parent_id
  path_part   = "votes"
  rest_api_id = var.rest_api_id
}

module "cors" {
  source = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.eurovota_api_votes.id
}

resource "aws_api_gateway_model" "vote_model" {
  rest_api_id  = var.rest_api_id
  name         = "vote"
  content_type = "application/json"
  schema       = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "VoteRequest",
  "type": "object",
  "properties": {
    "countryName": {
      "type": "string",
      "minLength": 1,
      "maxLength": 50
    },
    "voteValue": {
      "type": "number"
    }
  },
  "required": ["countryName", "voteValue"],
  "additionalProperties": false
}
EOF
}

resource "aws_api_gateway_method" "vote_method" {
  authorization = "COGNITO_USER_POOLS"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  rest_api_id   = var.rest_api_id
  authorizer_id = var.authorizer_id

  request_parameters = {
    "method.request.header.Authorization" : true,
    "method.request.path.userId" : true
  }
  request_models = {
    "application/json" = aws_api_gateway_model.vote_model.name
  }
}

resource "aws_api_gateway_integration" "vote_integration" {
  rest_api_id = var.rest_api_id
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  http_method = aws_api_gateway_method.vote_method.http_method

  type                    = "HTTP"
  uri                     = "${var.protocol_type}${var.votes_nlb_dns}/${aws_api_gateway_resource.eurovota_api_votes.path_part}"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = var.eurovota_votes_vpc_link

  cache_key_parameters = [
    "integration.request.header.Authorization",
    "method.request.header.Authorization"
  ]
  request_parameters = {
    "integration.request.header.Authorization" : "method.request.header.Authorization"
  }
}

resource "aws_api_gateway_method_response" "vote_response_200" {

  http_method = aws_api_gateway_method.vote_method.http_method
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  rest_api_id = var.rest_api_id
  status_code = "200"
  response_models = {
    "application/json" : "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = false,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Location" : true
  }

}

resource "aws_api_gateway_integration_response" "vote_integration_response_200" {
  http_method = aws_api_gateway_method.vote_method.http_method
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  response_templates = {
    "application/json" : ""
  }
  rest_api_id = var.rest_api_id
  status_code = aws_api_gateway_method_response.vote_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST'",
    "method.response.header.Location" : "integration.response.header.Location"

  }
}

resource "aws_api_gateway_method_response" "vote_response_400" {

  http_method = aws_api_gateway_method.vote_method.http_method
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  rest_api_id = var.rest_api_id
  status_code = "400"
  response_models = {
    "application/json" : "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = false,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }

}

resource "aws_api_gateway_integration_response" "vote_integration_response_400" {
  http_method = aws_api_gateway_method.vote_method.http_method
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  response_templates = {
    "application/json" : ""
  }
  rest_api_id = var.rest_api_id
  status_code = aws_api_gateway_method_response.vote_response_400.status_code
  selection_pattern = "4(?!09)\\d{2}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST'"
  }

}

resource "aws_api_gateway_method_response" "registry_response_409" {

  http_method = aws_api_gateway_method.vote_method.http_method
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  rest_api_id = var.rest_api_id
  status_code = "409"
  response_models = {
    "application/json" : "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }

}

resource "aws_api_gateway_integration_response" "registry_integration_response_409" {
  http_method = aws_api_gateway_method.vote_method.http_method
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  response_templates = {
    "application/json" : ""
  }
  rest_api_id       = var.rest_api_id
  status_code       = aws_api_gateway_method_response.registry_response_409.status_code
  selection_pattern = "409"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST'"
  }
}

// GET method

resource "aws_api_gateway_method" "vote_get_method" {
  authorization = "COGNITO_USER_POOLS"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  rest_api_id   = var.rest_api_id
  authorizer_id = var.authorizer_id

  request_parameters = {
    "method.request.header.Authorization" : true
  }
}

resource "aws_api_gateway_integration" "vote_get_integration" {
  rest_api_id = var.rest_api_id
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  http_method = aws_api_gateway_method.vote_get_method.http_method

  type                    = "HTTP"
  uri                     = "${var.protocol_type}${var.votes_nlb_dns}/${aws_api_gateway_resource.eurovota_api_votes.path_part}"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = var.eurovota_votes_vpc_link

  cache_key_parameters = [
    "integration.request.header.Authorization",
    "method.request.header.Authorization"
  ]
  request_parameters = {
    "integration.request.header.Authorization" : "method.request.header.Authorization"
  }
}

resource "aws_api_gateway_method_response" "vote_get_response_200" {

  http_method = aws_api_gateway_method.vote_get_method.http_method
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  rest_api_id = var.rest_api_id
  status_code = "200"
  response_models = {
    "application/json" : "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = false,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }

}

resource "aws_api_gateway_integration_response" "vote_get_integration_response_200" {
  http_method = aws_api_gateway_method.vote_get_method.http_method
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  response_templates = {
    "application/json" : ""
  }
  rest_api_id = var.rest_api_id
  status_code = aws_api_gateway_method_response.vote_get_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET'"
  }
}

resource "aws_api_gateway_method_response" "registry_response_400" {

  http_method = aws_api_gateway_method.vote_get_method.http_method
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  rest_api_id = var.rest_api_id
  status_code = "400"
  response_models = {
    "application/json" : "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = false,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
  }

}

resource "aws_api_gateway_integration_response" "validate_integration_response_400" {
  http_method        = aws_api_gateway_method.vote_get_method.http_method
  resource_id        = aws_api_gateway_resource.eurovota_api_votes.id
  response_templates = {
    "application/json" : ""
  }
  rest_api_id       = var.rest_api_id
  status_code       = aws_api_gateway_method_response.registry_response_400.status_code
  selection_pattern = "4\\d{2}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET'",
  }
}
/*

// OPTIONS method

resource "aws_api_gateway_method" "votes_options_method" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.eurovota_api_votes.id
  rest_api_id   = var.rest_api_id

}

resource "aws_api_gateway_integration" "votes_options_integration" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.eurovota_api_votes.id
  http_method = aws_api_gateway_method.votes_options_method.http_method

  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"

  connection_type = "INTERNET"

  request_templates = {
    "application/json" : "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "votes_options_integration_response_200" {
  http_method = aws_api_gateway_method.votes_options_method.http_method
  resource_id = aws_api_gateway_resource.eurovota_api_votes.id
  response_templates = {
    "application/json" : ""
  }
  rest_api_id = var.rest_api_id
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" : "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" : "'OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" : "'*'"
  }
}

resource "aws_api_gateway_method_response" "votes_options_response_200" {

  http_method = aws_api_gateway_method.votes_options_method.http_method
  resource_id = aws_api_gateway_resource.eurovota_api_votes.id
  rest_api_id = var.rest_api_id
  status_code = "200"
  response_models = {
    "application/json" : "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" : false,
    "method.response.header.Access-Control-Allow-Methods" : false,
    "method.response.header.Access-Control-Allow-Origin" : false
  }

}*/



