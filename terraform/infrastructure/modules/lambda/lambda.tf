module "role-permission" {
  source = "../role-permission"
}

resource "aws_lambda_function" "payment_validation" {
  filename         = "payment-validation.zip"
  function_name    = "payment_validation_function"
  role             = module.role-permission.lambda_exec_role_arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = filebase64sha256("./payment-validation.zip")
}

resource "aws_lambda_function" "process_payment" {
  filename         = "process-payment.zip"
  function_name    = "process_payment_function"
  role             = module.role-permission.lambda_exec_role_arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = filebase64sha256("./process-payment.zip")
}