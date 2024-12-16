resource "aws_lambda_function" "tech_challenge_lambda_authorizer" {
  filename         = data.archive_file.tech_challenge_lambda_zip.source_file
  function_name    = "java_lambda_authorizer"
  role             = data.aws_iam_role.labrole.arn
  handler          = "com.fiap.techchallenge.fastfood.lambda.LambdaHandler::handleRequest"
  runtime          = "java17"
  memory_size      = 512
  timeout          = 20

  environment {
    variables = {
      COGNITO_USER_POOL_ID = var.cognito_user_pool_id
      API_GATEWAY_STAGE    = var.api_gateway_stage_name
      LOG_LEVEL            = "INFO"
      STAGE                = "production"
    }
  }
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tech_challenge_lambda_authorizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.api_gateway_arn
}