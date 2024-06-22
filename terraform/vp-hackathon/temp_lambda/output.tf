output "public_new_payment_lambda_invoke_arn" {
  value = aws_lambda_function.vp_public_new_payment_lambda.invoke_arn
}

output "public_new_payment_lambda_function_name" {
  value = aws_lambda_function.vp_public_new_payment_lambda.function_name
}

output "process_payment_lambda_arn" {
  value = aws_lambda_function.vp_process_payment_lambda.arn
}

output "notification_lambda_arn" {
  value = aws_lambda_function.vp_payment_notification_lambda.arn
}

output "payment_validation_lambda_arn" {
  value = aws_lambda_function.vp_payment_validation_lambda.arn
}
