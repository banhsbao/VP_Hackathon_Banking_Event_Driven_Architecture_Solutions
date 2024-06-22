data "aws_caller_identity" "current" {}

resource "aws_iam_role" "iam_role_step_function" {
  name = "step_functions_role_poc_sf"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "lambda_access_policy" {
  statement {
    actions = [
      "lambda:*"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "step_functions_policy_lambda" {
  name   = "step_functions_policy_lambda_policy_all_poc_sf"
  policy = data.aws_iam_policy_document.lambda_access_policy.json
}

resource "aws_iam_role_policy_attachment" "step_functions_to_lambda" {
  role       = aws_iam_role.iam_role_step_function.name
  policy_arn = aws_iam_policy.step_functions_policy_lambda.arn
}
