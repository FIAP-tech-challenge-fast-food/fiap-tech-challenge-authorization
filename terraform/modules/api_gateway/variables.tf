variable "region" {
  default = "us-east-1"
}

variable "projectName" {
  default = "tech-challenge"
}

variable "auto_deploy" {
  type        = bool
  default     = true
}

variable "lambda_authorizer_invoke_arn" {
  type = string
}

variable "cognito_user_pool_id" {}

variable "cognito_user_pool_endpoint" {}

variable "cognito_user_pool_client_id" {}