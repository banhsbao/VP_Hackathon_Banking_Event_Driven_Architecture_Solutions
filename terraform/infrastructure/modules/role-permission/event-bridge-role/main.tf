data "aws_caller_identity" "current" {}


resource "aws_iam_role" "vp_lambda_exec" {
  name = "vp_lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy_for_event_bridge" {
  name = "lambda_policy_for_event_bridge"
  role = aws_iam_role.vp_lambda_exec.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "logs:CreateLogGroup",
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:*:*:log-group:/aws/lambda/*:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "events:PutEvents",
        "Principal" : "*",
        "Resource" : "arn:aws:events:${var.aws_region}:${data.aws_caller_identity.current.account_id}:event-bus/my-event-bus"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.vp_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# resource "aws_lambda_permission" "allow_eventbridge" {
#   statement_id  = "AllowExecutionFromEventBridge"
#   action        = "lambda:InvokeFunction"
#   function_name = var.payment_notification_function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = var.my_event_bus_arn
# }

