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

  environment {
    variables = {
      RDS_HOST     = var.rds_host
      RDS_USER     = var.rds_user
      RDS_PASSWORD = var.rds_password
      RDS_DATABASE = var.rds_database
      RDS_PORT     = var.rds_port
    }
  }
}

resource "aws_lambda_function" "process_payment" {
  filename         = "process-payment.zip"
  function_name    = "process_payment_function"
  role             = module.role-permission.lambda_exec_role_arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = filebase64sha256("./process-payment.zip")

  environment {
    variables = {
      RDS_HOST     = var.rds_host
      RDS_USER     = var.rds_user
      RDS_PASSWORD = var.rds_password
      RDS_DATABASE = var.rds_database
      RDS_PORT     = var.rds_port
    }
  }
}

resource "aws_lambda_function" "payment_notification" {
  filename         = "payment-notification.zip"
  function_name    = "payment_notification_function"
  role             = module.role-permission.lambda_exec_role_arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = filebase64sha256("./payment-notification.zip")

  environment {
    variables = {
      RDS_HOST     = var.rds_host
      RDS_USER     = var.rds_user
      RDS_PASSWORD = var.rds_password
      RDS_DATABASE = var.rds_database
      RDS_PORT     = var.rds_port
    }
  }
}
