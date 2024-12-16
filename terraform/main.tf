module "lambda" {
  source = "./modules/lambda"

  cognito_user_pool_id   = module.cognito.user_pool_id
  api_gateway_arn        = module.api_gateway.api_gateway_execution_arn
  api_gateway_stage_name = module.api_gateway.api_gateway_stage_name
}

module "api_gateway" {
  source = "./modules/api_gateway"

  cognito_user_pool_id         = module.cognito.user_pool_id
  cognito_user_pool_client_id  = module.cognito.user_pool_client_id
  cognito_user_pool_endpoint   = module.cognito.user_pool_endpoint
  lambda_authorizer_invoke_arn = module.lambda.tech_challenge_lambda_authorizer_invoke_arn
}

module "cognito" {
  source = "./modules/cognito"
}