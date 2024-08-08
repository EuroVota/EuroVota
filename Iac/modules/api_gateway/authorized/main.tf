resource "aws_api_gateway_authorizer" "authorizer" {
  identity_source = "method.request.header.Authorization"
  name = "User-cognito"
  provider_arns = [var.user_pool_arn]
  rest_api_id = var.rest_api_id
  type = "COGNITO_USER_POOLS"
}