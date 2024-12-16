variable "region" {
  default = "us-east-1"
}

variable "projectName" {
  default = "tech-challenge"
}

variable "api_gateway_arn" {
  type        = string
}

variable "cognito_user_pool_id" {}

variable "api_gateway_stage_name" {}