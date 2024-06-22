resource "aws_cognito_user_pool" "cognito_pool" {
  name = "vp-user-pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  tags = {
    Name = "vp-user-pool"
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                         = "vp-user-pool-client"
  user_pool_id                 = aws_cognito_user_pool.cognito_pool.id
  generate_secret              = false
  allowed_oauth_flows          = ["code", "implicit"]
  allowed_oauth_scopes         = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  callback_urls                = ["https://trustsolute.com/callback"]
  logout_urls                  = ["https://trustsolute.com/logout"]
  supported_identity_providers = ["COGNITO"]

  # Optional: Set additional client settings
  allowed_oauth_flows_user_pool_client = true
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name            = "cognito-authorizer"
  rest_api_id     = var.api_gateway_id
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [aws_cognito_user_pool.cognito_pool.arn]
  identity_source = "method.request.header.Authorization"
}

resource "aws_cognito_user_pool_domain" "cognito_domain" {
  domain       = "vp-user"
  user_pool_id = aws_cognito_user_pool.cognito_pool.id
}
