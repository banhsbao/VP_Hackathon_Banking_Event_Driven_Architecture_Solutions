variable "ecr_repository_url" {
  default = "example"
}

variable "codebuild_role_arn" {
  default = "example"
}

variable "env_AWS_REGION" {
  default = "example"
}

variable "env_AWS_ACCOUNT_ID" {
  default = "example"
}
variable "env_SERVERLESS_ACCESS_KEY" {
  default = "example"
}
variable "env_RDS_DB" {
  default = "example"
}
variable "env_RDS_HOST" {
  default = "example"
}
variable "env_RDS_USER" {
  default = "example"
}
variable "env_RDS_PASSWORD" {
  default = "example"
}
variable "env_LOG_LEVEL" {
  default = "example"
}
variable "env_IAM_LAMDA_ROLE_ARN" {
  type = string
}
variable "env_ENV_NAME" {
  type = string
}
variable "env_EVENT_BRIDGE_CREATE_PAYMENT_EVENT" {
  type = string
}
variable "env_STATE_PAYMENT_ARN" {
  type = string
}
