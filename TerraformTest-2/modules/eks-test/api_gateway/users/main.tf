resource "aws_api_gateway_resource" "eurovota_api_users" {
  parent_id   = var.parent_id
  path_part   = "users"
  rest_api_id = var.rest_api_id
}

module "registry" {
  source                  = "./registry"
  parent_id               = var.parent_id
  rest_api_id             = var.rest_api_id
  protocol_type           = var.protocol_type
  users_nlb_dns           = var.users_nlb_dns
  eurovota_users_vpc_link = var.eurovota_users_vpc_link
  resource_id             = aws_api_gateway_resource.eurovota_api_users.id
  resource_path           = aws_api_gateway_resource.eurovota_api_users.path_part
}

module "get_by_id" {
  source                  = "./get_by_id"
  parent_id               = aws_api_gateway_resource.eurovota_api_users.id
  rest_api_id             = var.rest_api_id
  protocol_type           = var.protocol_type
  users_nlb_dns           = var.users_nlb_dns
  eurovota_users_vpc_link = var.eurovota_users_vpc_link
  authorizer_id           = var.authorizer_id
  parent_path             = aws_api_gateway_resource.eurovota_api_users.path_part
}

module "validate" {
  source                  = "./validate"
  parent_id               = aws_api_gateway_resource.eurovota_api_users.id
  rest_api_id             = var.rest_api_id
  protocol_type           = var.protocol_type
  users_nlb_dns           = var.users_nlb_dns
  eurovota_users_vpc_link = var.eurovota_users_vpc_link
  resource_id             = aws_api_gateway_resource.eurovota_api_users.id
  resource_path           = aws_api_gateway_resource.eurovota_api_users.path_part
}


