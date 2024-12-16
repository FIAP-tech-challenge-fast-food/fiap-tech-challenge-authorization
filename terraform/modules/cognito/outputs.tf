output "user_pool_id" {
  value = aws_cognito_user_pool.users_pool_tech_challenge.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.users_pool_client_tech_challenge.id
}

output "user_pool_endpoint" {
  value = aws_cognito_user_pool.users_pool_tech_challenge.endpoint
}
