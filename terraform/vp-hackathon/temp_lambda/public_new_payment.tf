resource "aws_lambda_function" "vp_public_new_payment_lambda" {
  package_type  = "Image"
  role          = data.aws_iam_role.lambda_role.arn
  image_uri     = var.public_new_payment_lambda_uri
  function_name = format("%s-%s", var.prefix, "public-new-payment")
  timeout       = 30

  environment {
    variables = {
      RDS_HOST = var.rds_host
      RDS_DB   = var.rds_db
      # RDS_USERNAME = data.aws_ssm_parameter.ssm_rds_username.value
      # RDS_PASSWORD = data.aws_ssm_parameter.ssm_rds_password.value
    }
  }


  tags = {
    Name = format("%s-%s", var.prefix, "public-new-payment")
  }

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [aws_security_group.vp_lambda_ssg.id]
  }
}
