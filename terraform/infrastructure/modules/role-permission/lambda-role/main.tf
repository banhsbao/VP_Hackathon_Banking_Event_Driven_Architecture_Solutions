data "aws_caller_identity" "current" {}

module "vp_lambda_role" {
  source = "../../../../../terraform-modules/aws/iam/iam-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "lambda.amazonaws.com",
            "appsync.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  iam_role_name        = "vp-lambda-role"
  iam_role_description = "Lambda iam role"
  environment          = var.environment
  owner                = "VP MoneyBoiz"
}

data "aws_iam_policy" "SecretsManagerReadWrite" {
  arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

data "aws_iam_policy" "AmazonSQSFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryReadOnly" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "AWSLambdaSQSQueueExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy" "AmazonSSMReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

data "aws_iam_policy" "AWSLambdaVPCAccessExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "lambda_allow_push_msg_to_sns_topic" {
  name = "${local.app_prefix}-AllowLambdaPushMsgToSNSTopic"
  role = module.vp_lambda_role.iam_role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish",
        ]
        Resource = "arn:aws:sns:*:${data.aws_caller_identity.current.account_id}:*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_allow_xray_wo_policy" {
  name = "${local.app_prefix}-AllowLambdaWriteOnlyToXRay"
  role = module.vp_lambda_role.iam_role_name
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
          "xray:GetSamplingStatisticSummaries"
        ],
        Resource : [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_allow_invoke_other_lambda" {
  name = "${local.app_prefix}-AllowLambdaInvokeOtherLambda"
  role = module.vp_lambda_role.iam_role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction",
        ]
        Resource = "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:function:*"
      },
    ]
  })
}

data "aws_kms_alias" "aws_lambda" {
  name = "alias/aws/lambda"
}


resource "aws_iam_role_policy" "lambda_allow_kms_decrypt" {
  name = "${local.app_prefix}-AllowLambdaKMSDecrypt"
  role = module.vp_lambda_role.iam_role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
        ]
        Resource = data.aws_kms_alias.aws_lambda.target_key_arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_secret_manager_rw" {
  role       = module.vp_lambda_role.iam_role_name
  policy_arn = data.aws_iam_policy.SecretsManagerReadWrite.arn
}

resource "aws_iam_role_policy_attachment" "lambda_ec2_container_registry_ro" {
  role       = module.vp_lambda_role.iam_role_name
  policy_arn = data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn
}

resource "aws_iam_role_policy_attachment" "lambda_s3_fa" {
  role       = module.vp_lambda_role.iam_role_name
  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_fa" {
  role       = module.vp_lambda_role.iam_role_name
  policy_arn = data.aws_iam_policy.AmazonSQSFullAccess.arn
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_er" {
  role       = module.vp_lambda_role.iam_role_name
  policy_arn = data.aws_iam_policy.AWSLambdaSQSQueueExecutionRole.arn
}

resource "aws_iam_role_policy_attachment" "lambda_basic_er" {
  role       = module.vp_lambda_role.iam_role_name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

resource "aws_iam_role_policy_attachment" "lambda_ssm_ro" {
  role       = module.vp_lambda_role.iam_role_name
  policy_arn = data.aws_iam_policy.AmazonSSMReadOnlyAccess.arn
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access_er" {
  role       = module.vp_lambda_role.iam_role_name
  policy_arn = data.aws_iam_policy.AWSLambdaVPCAccessExecutionRole.arn
}

resource "aws_iam_role_policy" "vp_lambda_role_policy" {
  name = "vp-lambda-role-policy"
  role = module.vp_lambda_role.iam_role_name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:*",
          "events:PutEvents",
          "states:StartExecution",
          "states:*",
          "events:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}
