output "api_gateway_stage_url" {
  description = "The url of the API Gateway stage"
  value = aws_api_gateway_stage.eurovota_api_stage.invoke_url
}