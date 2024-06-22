resource "aws_codebuild_project" "vp_codebuid" {
  name         = "vp-codebuild"
  service_role = var.codebuild_role_arn
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "RDS_DB"
      value = var.env_RDS_DB
    }
    environment_variable {
      name  = "RDS_HOST"
      value = var.env_RDS_HOST
    }
    environment_variable {
      name  = "RDS_USER"
      value = var.env_RDS_USER
    }
    environment_variable {
      name  = "RDS_PASSWORD"
      value = var.env_RDS_PASSWORD
    }
    environment_variable {
      name  = "LOG_LEVEL"
      value = var.env_LOG_LEVEL
    }
    environment_variable {
      name  = "SERVERLESS_ACCESS_KEY"
      value = var.env_SERVERLESS_ACCESS_KEY
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.env_AWS_ACCOUNT_ID
    }
    environment_variable {
      name  = "AWS_REGION"
      value = var.env_AWS_REGION
    }
    environment_variable {
      name  = "ENV_NAME"
      value = var.env_ENV_NAME
    }
    environment_variable {
      name  = "LAMBDA_ROLE"
      value = var.env_IAM_LAMDA_ROLE_ARN
    }
    environment_variable {
      name  = "EVENT_BRIDGE_CREATE_PAYMENT_EVENT"
      value = var.env_EVENT_BRIDGE_CREATE_PAYMENT_EVENT
    }
    environment_variable {
      name  = "STATE_PAYMENT_ARN"
      value = var.env_STATE_PAYMENT_ARN
    }
  }
}
