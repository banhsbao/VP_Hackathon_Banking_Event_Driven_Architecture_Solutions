data "aws_lambda_function" "payment_notification" {
  function_name = "dev-payment-notification"
}

data "aws_lambda_function" "payment_validation_lambda" {
  function_name = "dev-payment-validation"
}

data "aws_lambda_function" "process_payment_lambda" {
  function_name = "dev-payment-process"
}

data "aws_lambda_function" "public_new_payment_lambda" {
  function_name = "dev-publish-new-payment"
}

data "aws_lambda_function" "start_payment_processing_lambda" {
  function_name = "dev-start-payment"
}

module "step_function_role" {
  source = "../../infrastructure/modules/role-permission/stepfunction-role"
}

module "step_function" {
  source                        = "../../infrastructure/modules/step-function"
  payment_notification_arn      = data.aws_lambda_function.payment_notification.arn
  payment_validation_lambda_arn = data.aws_lambda_function.payment_validation_lambda.arn
  process_payment_lambda_arn    = data.aws_lambda_function.process_payment_lambda.arn
  step_functions_role_arn       = module.step_function_role.iam_role_step_function_arn
}

module "api_gateway" {
  source                         = "../../infrastructure/modules/api-gateway"
  public_new_payment_lambda_name = data.aws_lambda_function.public_new_payment_lambda.function_name
  public_new_payment_invoke_arn  = data.aws_lambda_function.public_new_payment_lambda.invoke_arn
}

# module "cognito" {
#   source         = "../../infrastructure/modules/cognito"
#   api_gateway_id = module.api_gateway.api_gateway_id
# }

module "event_bridge" {
  source                             = "../../infrastructure/modules/event-bridge"
  payment_notification_function_name = data.aws_lambda_function.payment_validation_lambda.function_name
  payment_notification_function_arn  = data.aws_lambda_function.payment_notification.arn
}


resource "aws_lambda_event_source_mapping" "sqs_lambda_trigger" {
  event_source_arn = module.event_bridge.sqs_queue_arn
  function_name    = data.aws_lambda_function.start_payment_processing_lambda.arn
  batch_size       = 1
  enabled          = true
}
