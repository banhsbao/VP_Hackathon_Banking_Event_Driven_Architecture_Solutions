resource "aws_api_gateway_rest_api" "vp_api_gw_rest_api" {
  name        = "VP-Group10-api"
  description = "API Gateway"
}

resource "aws_api_gateway_resource" "vp_payment_resource" {
  rest_api_id = aws_api_gateway_rest_api.vp_api_gw_rest_api.id
  parent_id   = aws_api_gateway_rest_api.vp_api_gw_rest_api.root_resource_id
  path_part   = "payment"
}

resource "aws_api_gateway_method" "payment_method" {
  rest_api_id   = aws_api_gateway_rest_api.vp_api_gw_rest_api.id
  resource_id   = aws_api_gateway_resource.vp_payment_resource.id
  http_method   = "POST"
  authorization = "NONE"
  request_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "payment_integration" {
  rest_api_id             = aws_api_gateway_rest_api.vp_api_gw_rest_api.id
  resource_id             = aws_api_gateway_resource.vp_payment_resource.id
  http_method             = aws_api_gateway_method.payment_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.public_new_payment_invoke_arn
}

resource "aws_api_gateway_resource" "vp_all_payment_resource" {
  rest_api_id = aws_api_gateway_rest_api.vp_api_gw_rest_api.id
  parent_id   = aws_api_gateway_rest_api.vp_api_gw_rest_api.root_resource_id
  path_part   = "all-payment"
}

resource "aws_api_gateway_method" "all_payment_method" {
  rest_api_id   = aws_api_gateway_rest_api.vp_api_gw_rest_api.id
  resource_id   = aws_api_gateway_resource.vp_all_payment_resource.id
  http_method   = "GET"
  authorization = "NONE"
  request_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "all_payment_integration" {
  rest_api_id             = aws_api_gateway_rest_api.vp_api_gw_rest_api.id
  resource_id             = aws_api_gateway_resource.vp_all_payment_resource.id
  http_method             = aws_api_gateway_method.all_payment_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.public_new_payment_invoke_arn
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.public_new_payment_lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.vp_api_gw_rest_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "all_payment_api_gateway" {
  statement_id  = "AllowAPIGatewayInvokeAllPayment"
  action        = "lambda:InvokeFunction"
  function_name = var.public_new_payment_lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.vp_api_gw_rest_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on = [
    aws_api_gateway_integration.payment_integration,
    aws_api_gateway_integration.all_payment_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.vp_api_gw_rest_api.id
  stage_name  = "prod"
}

resource "aws_api_gateway_stage" "gateway_state" {
  deployment_id = aws_api_gateway_deployment.api_gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.vp_api_gw_rest_api.id
  stage_name    = "prod"
}
