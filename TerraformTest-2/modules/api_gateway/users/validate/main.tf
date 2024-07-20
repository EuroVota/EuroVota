resource "aws_api_gateway_resource" "eurovota_api_validate" {
  parent_id   = var.parent_id
  path_part   = "validate"
  rest_api_id = var.rest_api_id

}

# Crear el modelo de solicitud
resource "aws_api_gateway_model" "validate_model" {
  rest_api_id  = var.rest_api_id
  name         = "validate"
  content_type = "application/json"
  schema       = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "ValidateRequest",
  "type": "object",
  "properties": {
    "phone": {
      "type": "string",
      "pattern": "^\\+\\d{1,15}$"
    },
    "code": {
      "type": "integer",
      "minimum": 0,
      "maximum": 999999
    }
  },
  "required": ["phone", "code"],
  "additionalProperties": false
}
EOF
}

resource "aws_api_gateway_method" "validate_method" {
  authorization = "NONE"
  http_method   = "PATCH"
  resource_id   = aws_api_gateway_resource.eurovota_api_validate.id
  rest_api_id   = var.rest_api_id

  request_models = {
    "application/json" = aws_api_gateway_model.validate_model.name
  }
}

resource "aws_api_gateway_integration" "validate_integration" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.eurovota_api_validate.id
  http_method = aws_api_gateway_method.validate_method.http_method

  type                    = "HTTP"
  uri                     = "${var.protocol_type}${var.users_nlb_dns}/${var.resource_path}/${aws_api_gateway_resource.eurovota_api_validate.path_part}"
  integration_http_method = "PATCH"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = var.eurovota_users_vpc_link
}

resource "aws_api_gateway_method_response" "validate_response_200" {

  http_method = aws_api_gateway_method.validate_method.http_method
  resource_id = aws_api_gateway_resource.eurovota_api_validate.id
  rest_api_id = var.rest_api_id
  status_code = "200"
  response_models = {
    "application/json" : "Empty"
  }


  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" : false
  }

}

resource "aws_api_gateway_integration_response" "validate_integration_response_200" {
  http_method = aws_api_gateway_method.validate_method.http_method
  resource_id = aws_api_gateway_resource.eurovota_api_validate.id
  response_templates = {
    "application/json" : ""
  }
  rest_api_id = var.rest_api_id
  status_code = aws_api_gateway_method_response.validate_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" : "'*'"
  }
}

resource "aws_api_gateway_method_response" "registry_response_400" {

  http_method = aws_api_gateway_method.validate_method.http_method
  resource_id = aws_api_gateway_resource.eurovota_api_validate.id
  rest_api_id = var.rest_api_id
  status_code = "400"
  response_models = {
    "application/json" : "Empty"
  }

}

resource "aws_api_gateway_integration_response" "validate_integration_response_400" {
  http_method = aws_api_gateway_method.validate_method.http_method
  resource_id = aws_api_gateway_resource.eurovota_api_validate.id
  response_templates = {
    "application/json" : ""
  }
  rest_api_id = var.rest_api_id
  status_code = aws_api_gateway_method_response.registry_response_400.status_code
  selection_pattern = "4\\d{2}"
}
resource "aws_api_gateway_method" "validate_options_method" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.eurovota_api_validate.id
  rest_api_id   = var.rest_api_id

}

resource "aws_api_gateway_integration" "validate_options_integration" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.eurovota_api_validate.id
  http_method = aws_api_gateway_method.validate_options_method.http_method

  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"

  connection_type = "INTERNET"

  request_templates = {
    "application/json" : "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "validate_options_integration_response_200" {
  http_method = aws_api_gateway_method.validate_options_method.http_method
  resource_id = aws_api_gateway_resource.eurovota_api_validate.id
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

resource "aws_api_gateway_method_response" "validate_options_response_200" {

  http_method = aws_api_gateway_method.validate_options_method.http_method
  resource_id = aws_api_gateway_resource.eurovota_api_validate.id
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

}



