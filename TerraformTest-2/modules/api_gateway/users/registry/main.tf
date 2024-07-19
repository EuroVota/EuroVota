module "cors" {
  source = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id = var.rest_api_id
  api_resource_id = var.resource_id
}

# Crear el modelo de solicitud
resource "aws_api_gateway_model" "registry_model" {
  rest_api_id  = var.rest_api_id
  name         = "register"
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

resource "aws_api_gateway_method" "register_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = var.resource_id
  rest_api_id   = var.rest_api_id

  request_models = {
    "application/json" = aws_api_gateway_model.registry_model.name
  }
}

resource "aws_api_gateway_integration" "registry_integration" {
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.register_method.http_method

  type                    = "HTTP"
  uri                     = "${var.protocol_type}${var.users_nlb_dns}/${var.resource_path}"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = var.eurovota_users_vpc_link
}

resource "aws_api_gateway_method_response" "registry_response_200" {

  http_method = aws_api_gateway_method.register_method.http_method
  resource_id = var.resource_id
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

resource "aws_api_gateway_integration_response" "registry_integration_response_200" {
  http_method = aws_api_gateway_method.register_method.http_method
  resource_id = var.resource_id
  response_templates = {
    "application/json" : ""
  }
  rest_api_id = var.rest_api_id
  status_code = aws_api_gateway_method_response.registry_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST'",
    "method.response.header.Location" : "integration.response.header.Location"
  }
}

resource "aws_api_gateway_method_response" "registry_response_400" {

  http_method = aws_api_gateway_method.register_method.http_method
  resource_id = var.resource_id
  rest_api_id = var.rest_api_id
  status_code = "400"
  response_models = {
    "application/json" : "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }

}

resource "aws_api_gateway_integration_response" "registry_integration_response_400" {
  http_method = aws_api_gateway_method.register_method.http_method
  resource_id = var.resource_id
  response_templates = {
    "application/json" : ""
  }
  rest_api_id       = var.rest_api_id
  status_code       = aws_api_gateway_method_response.registry_response_400.status_code
  selection_pattern = "4(?!09)\\d{2}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST'"
  }
}

resource "aws_api_gateway_method_response" "registry_response_409" {

  http_method = aws_api_gateway_method.register_method.http_method
  resource_id = var.resource_id
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
  http_method = aws_api_gateway_method.register_method.http_method
  resource_id = var.resource_id
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

