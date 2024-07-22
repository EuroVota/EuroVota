resource "aws_api_gateway_resource" "eurovota_api_login" {
  parent_id   = var.parent_id
  path_part   = "login"
  rest_api_id = var.rest_api_id
}

module "cors" {
  source = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id = var.rest_api_id
  api_resource_id = aws_api_gateway_resource.eurovota_api_login.id
}

# Crear el modelo de solicitud
resource "aws_api_gateway_model" "login_model" {
  rest_api_id  = var.rest_api_id
  name         = "login2"
  content_type = "application/json"
  schema       = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "LoginRequest",
  "type": "object",
  "properties": {
    "phone": {
      "type": "string",
      "pattern": "^\\+\\d{1,15}$"
    },
    "password": {
      "type": "string",
      "minLength": 8,
      "maxLength": 20,
      "pattern": "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
    }
  },
  "required": ["phone", "password"],
  "additionalProperties": false
}
EOF
}

resource "aws_api_gateway_method" "login_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.eurovota_api_login.id
  rest_api_id   = var.rest_api_id

  request_models = {
    "application/json" = aws_api_gateway_model.login_model.name
  }
}

resource "aws_api_gateway_integration" "login_integration" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.eurovota_api_login.id
  http_method = aws_api_gateway_method.login_method.http_method

  type                    = "HTTP"
  uri                     = "${var.protocol_type}${var.users_nlb_dns}/${aws_api_gateway_resource.eurovota_api_login.path_part}"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = var.eurovota_users_vpc_link
}

resource "aws_api_gateway_method_response" "login_response_200" {

  http_method = aws_api_gateway_method.login_method.http_method
  resource_id = aws_api_gateway_resource.eurovota_api_login.id
  rest_api_id = var.rest_api_id
  status_code = "200"
  response_models = {
    "application/json" : "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }

}

resource "aws_api_gateway_integration_response" "login_integration_response_200" {
  http_method = aws_api_gateway_method.login_method.http_method
  resource_id = aws_api_gateway_resource.eurovota_api_login.id
  response_templates = {
    "application/json" : ""
  }
  rest_api_id = var.rest_api_id
  status_code = aws_api_gateway_method_response.login_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_method_response" "login_response_400" {

  http_method = aws_api_gateway_method.login_method.http_method
  resource_id = aws_api_gateway_resource.eurovota_api_login.id
  rest_api_id = var.rest_api_id
  status_code = "400"
  response_models = {
    "application/json" : "Empty"
  }

}

resource "aws_api_gateway_integration_response" "login_integration_response_400" {
  http_method = aws_api_gateway_method.login_method.http_method
  resource_id = aws_api_gateway_resource.eurovota_api_login.id
  response_templates = {
    "application/json" : ""
  }
  rest_api_id = var.rest_api_id
  status_code = aws_api_gateway_method_response.login_response_400.status_code
  selection_pattern = "4\\d{2}"
}


