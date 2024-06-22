data "aws_caller_identity" "current" {}

# data "aws_db_instance" "vp_db" {
#   db_instance_identifier = var.rds_identifier
# }

module "code_star" {
  source = "../../infrastructure/modules/code-star-connection"
}

module "role_lambda" {
  source      = "../../infrastructure/modules/role-permission/lambda-role"
  environment = var.environment
  domain_name = var.domain_name
}

module "role_codebuild" {
  source = "../../infrastructure/modules/role-permission/codebuid-role"
}

module "role_codepipeline" {
  source                    = "../../infrastructure/modules/role-permission/codepipeline-role"
  code_build_arn            = module.code_build.code_build_arn
  codepipeline_bucket_arn   = module.bucket.codepipeline_bucket_arn
  code_start_connection_arn = module.code_star.code_star_connection_arn
}

module "bucket" {
  source = "../../infrastructure/modules/s3"
}

module "ecr" {
  source = "../../infrastructure/modules/registry"
}

module "ecr_role" {
  source   = "../../infrastructure/modules/role-permission/ecr-role"
  ecr_name = module.ecr.ecr_name
}

module "code_build" {
  source                                = "../../infrastructure/modules/code-build"
  ecr_repository_url                    = module.ecr.ecr_repository_url
  codebuild_role_arn                    = module.role_codebuild.iam_codebuild_role_arn
  env_AWS_REGION                        = var.aws_region
  env_AWS_ACCOUNT_ID                    = data.aws_caller_identity.current.account_id
  env_SERVERLESS_ACCESS_KEY             = var.serverless_access_key
  env_LOG_LEVEL                         = "ERROR"
  env_RDS_DB                            = "Test"
  env_RDS_HOST                          = "Test"
  env_RDS_PASSWORD                      = var.db_password
  env_RDS_USER                          = var.db_username
  env_IAM_LAMDA_ROLE_ARN                = module.role_lambda.iam_lambda_role_arn
  env_ENV_NAME                          = var.env_ENV_NAME
  env_EVENT_BRIDGE_CREATE_PAYMENT_EVENT = var.env_EVENT_BRIDGE_CREATE_PAYMENT_EVENT
  env_STATE_PAYMENT_ARN                 = var.env_STATE_PAYMENT_ARN
}

module "code-pipeline" {
  source                 = "../../infrastructure/modules/code-pipeline"
  full_repository_id     = "VP-Hackathon/vp_product"
  code_connection_arn    = module.code_star.code_star_connection_arn
  vp_lambda_service_name = module.code_build.vp_lambda_service_name
  codepipeline_bucket    = module.bucket.codepipeline_bucket
  codepipeline_role_arn  = module.role_codepipeline.iam_codepipeline_role
}

