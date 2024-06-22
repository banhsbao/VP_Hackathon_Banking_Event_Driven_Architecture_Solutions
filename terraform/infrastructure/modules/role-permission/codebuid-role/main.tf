resource "aws_iam_role" "iam_codebuild_role" {
  name = "vp-codebuild-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codebuild.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "iam_codebuild_policy" {
  role = aws_iam_role.iam_codebuild_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken",
          "ecr:PutImage",
          "ecr:CreateRepository",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:*",
          "cloudformation:CreateStack",
          "cloudformation:DescribeStacks",
          "cloudformation:UpdateStack",
          "cloudformation:DeleteStack",
          "cloudformation:CreateChangeSet",
          "cloudformation:DescribeChangeSet",
          "cloudformation:ExecuteChangeSet",
          "cloudformation:DescribeStackResources",
          "cloudformation:ListStackResources",
          "cloudformation:DeleteChangeSet",
          "cloudformation:ListStacks",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PassRole",
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:InvokeFunction",
          "lambda:DeleteFunction",
          "apigateway:CreateRestApi",
          "apigateway:DeleteRestApi",
          "apigateway:POST",
          "apigateway:PUT",
          "apigateway:PATCH",
          "apigateway:DELETE",
          "events:PutRule",
          "events:PutTargets",
          "events:RemoveTargets",
          "events:DeleteRule",
          "sns:CreateTopic",
          "sns:DeleteTopic",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "dynamodb:CreateTable",
          "dynamodb:DeleteTable",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "ecr:DescribeImages",
          "cloudformation:DescribeStackResource",
          "ecr:*",
          "logs:*",
          "lambda:*",
          "apigateway:*",
          "events:*",
          "sns:*",
          "cloudformation:*",
          "ecr:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_codecommit_power_user" {
  role       = aws_iam_role.iam_codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}
