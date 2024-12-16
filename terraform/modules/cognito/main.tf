resource "aws_cognito_user_pool" "users_pool_tech_challenge" {
  name                     = "users-pool-${var.projectName}"
  mfa_configuration        = "OFF"
  auto_verified_attributes = []

  schema {
    name                    = "cpf"
    attribute_data_type     = "String"
    developer_only_attribute = false
    mutable                 = false
    required                = false
    string_attribute_constraints {
      min_length = 11
      max_length = 11
    }
  }

  username_configuration {
    case_sensitive = false
  }

  tags = {
    Name = "users_pool_tech_challenge"
  }
}

resource "aws_cognito_user_pool_client" "users_pool_client_tech_challenge" {
  name                = "users-pool-client-${var.projectName}"
  explicit_auth_flows = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_ADMIN_USER_PASSWORD_AUTH"]
  user_pool_id        = aws_cognito_user_pool.users_pool_tech_challenge.id
}
