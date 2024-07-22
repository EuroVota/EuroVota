resource "aws_api_gateway_rest_api" "eurovota_api" {
  name = "eurovota-api"
}

resource "aws_api_gateway_resource" "eurovota_api_root" {
  parent_id   = aws_api_gateway_rest_api.eurovota_api.root_resource_id
  path_part   = "eurovota-api"
  rest_api_id = aws_api_gateway_rest_api.eurovota_api.id
}

resource "aws_api_gateway_vpc_link" "eurovota_vpc_link" {
  name        = "eurovota-vpc-link"
  target_arns = [var.nlb_arn]
}

module "auth" {
  source        = "./authorized"
  user_pool_arn = var.user_pool_arn
  rest_api_id   = aws_api_gateway_rest_api.eurovota_api.id
}

module "login" {
  source                  = "./login"
  parent_id               = aws_api_gateway_resource.eurovota_api_root.id
  rest_api_id             = aws_api_gateway_rest_api.eurovota_api.id
  protocol_type           = var.protocol_type
  nlb_dns                 = var.nlb_dns
  eurovota_vpc_link       = aws_api_gateway_vpc_link.eurovota_vpc_link.id
}

module "users" {
  source                  = "./users"
  parent_id               = aws_api_gateway_resource.eurovota_api_root.id
  rest_api_id             = aws_api_gateway_rest_api.eurovota_api.id
  protocol_type           = var.protocol_type
  nlb_dns                 = var.nlb_dns
  eurovota_vpc_link       = aws_api_gateway_vpc_link.eurovota_vpc_link.id
  authorizer_id           = module.auth.authorizer_id

}

module "cors" {
  source = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id = aws_api_gateway_rest_api.eurovota_api.id
  api_resource_id = aws_api_gateway_resource.eurovota_api_root.id
}

module "votes" {
  source                  = "./votes"
  parent_id               = aws_api_gateway_resource.eurovota_api_root.id
  rest_api_id             = aws_api_gateway_rest_api.eurovota_api.id
  protocol_type           = var.protocol_type
  nlb_dns                 = var.nlb_dns
  eurovota_vpc_link       = aws_api_gateway_vpc_link.eurovota_vpc_link.id
  authorizer_id           = module.auth.authorizer_id
}

resource "aws_api_gateway_deployment" "eurovota_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.eurovota_api.id

  stage_description = "Deployed at ${timestamp()}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "eurovota_api_stage" {
  deployment_id = aws_api_gateway_deployment.eurovota_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.eurovota_api.id
  stage_name    = "eurovota-test"
}


