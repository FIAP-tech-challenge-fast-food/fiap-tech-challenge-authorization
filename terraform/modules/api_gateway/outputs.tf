output "api_gateway_execution_arn" {
  value       = aws_apigatewayv2_api.api_gateway.execution_arn
}

output "api_gateway_id" {
  value       = aws_apigatewayv2_api.api_gateway.id
}

output "api_gateway_invoke_url" {
  value       = aws_apigatewayv2_api.api_gateway.api_endpoint
}

output "api_gateway_stage_name" {
  value = aws_apigatewayv2_stage.default_stage.name
}
