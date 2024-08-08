resource "aws_api_gateway_rest_api" "eurovota_api" {
  name = "eurovota-api-eks"
}

resource "aws_api_gateway_resource" "eurovota_api_root" {
  parent_id   = aws_api_gateway_rest_api.eurovota_api.root_resource_id
  path_part   = "eurovota-api"
  rest_api_id = aws_api_gateway_rest_api.eurovota_api.id
}

data "aws_lb" "users-nlb-eks" {
  tags = {
    "kubernetes.io/service-name" = "default/users"
  }
}

data "aws_lb" "votes-nlb-eks" {
  tags = {
    "kubernetes.io/service-name" = "default/votes"
  }
}


resource "aws_api_gateway_vpc_link" "eurovota_users_vpc_link" {
  name        = "eurovota-users-vpc-link-eks"
  target_arns = [data.aws_lb.users-nlb-eks.arn]
}

resource "aws_api_gateway_vpc_link" "eurovota_votes_vpc_link" {
  name        = "eurovota-votes-vpc-link-eks"
  target_arns = [data.aws_lb.votes-nlb-eks.arn]
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
  users_nlb_dns           = data.aws_lb.users-nlb-eks.dns_name
  eurovota_users_vpc_link = aws_api_gateway_vpc_link.eurovota_users_vpc_link.id
}

module "users" {
  source                  = "./users"
  parent_id               = aws_api_gateway_resource.eurovota_api_root.id
  rest_api_id             = aws_api_gateway_rest_api.eurovota_api.id
  protocol_type           = var.protocol_type
  users_nlb_dns           = data.aws_lb.users-nlb-eks.dns_name
  eurovota_users_vpc_link = aws_api_gateway_vpc_link.eurovota_users_vpc_link.id
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
  votes_nlb_dns           = data.aws_lb.votes-nlb-eks.dns_name
  eurovota_votes_vpc_link = aws_api_gateway_vpc_link.eurovota_votes_vpc_link.id
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
  stage_name    = "eurovota-test-eks"
}


