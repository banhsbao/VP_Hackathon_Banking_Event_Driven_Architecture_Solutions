# Step Functions State Machine
resource "aws_sfn_state_machine" "payment_processor" {
  name     = "PaymentProcessor"
  role_arn = var.step_functions_role_arn

  definition = <<EOF
{
    "Comment": "execute lambdas",
    "StartAt": "PaymentValidation",
    "States": {
        "PaymentValidation": {
            "Type": "Task",
            "Resource": "${var.payment_validation_lambda_arn}",
            "Next": "IsPaymentValid"
        },
        "IsPaymentValid": {
            "Type": "Choice",
            "Choices": [
            {
                "Variable": "$.statusCode",
                "NumericEquals": 200,
                "Next": "ProcessPayment"
            }
            ],
            "Default": "NotifyPayment"
        },
        "ProcessPayment": {
            "Type": "Task",
            "Resource": "${var.process_payment_lambda_arn}",
            "End": true
        },
        "NotifyPayment": {
            "Type": "Task",
            "Resource": "${var.payment_notification_arn}",
            "End": true
        }
    }
}
EOF
}
