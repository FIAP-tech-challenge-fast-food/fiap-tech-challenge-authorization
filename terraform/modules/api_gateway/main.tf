resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "${var.projectName}-api-gateway"
  protocol_type = "HTTP"

  tags = {
    Project = var.projectName
    Environment = "Production"
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                  = aws_apigatewayv2_api.api_gateway.id
  integration_type        = "AWS_PROXY"
  integration_uri         = var.lambda_authorizer_invoke_arn
  payload_format_version  = "2.0"
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = var.auto_deploy

  tags = {
    Project = var.projectName
    Stage   = "Default"
  }
}

resource "aws_apigatewayv2_authorizer" "cognito_authorizer" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  authorizer_type  = "JWT"
  name             = "${var.projectName}-cognito-authorizer"

  jwt_configuration {
    audience = [var.cognito_user_pool_client_id]
    issuer   = "https://${var.cognito_user_pool_endpoint}"
  }

  identity_sources = ["$request.header.Authorization"]
}
