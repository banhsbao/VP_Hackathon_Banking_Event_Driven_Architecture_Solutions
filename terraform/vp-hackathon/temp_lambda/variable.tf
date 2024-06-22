variable "public_new_payment_lambda_uri" {
  default = "example"
}

variable "prefix" {
  default = "example"
}

variable "rds_host" {
  default = "example"
}

variable "rds_db" {
  default = "example"
}

variable "private_subnets" {
  type = list(string)
}

variable "payment_validation_lambda_uri" {
  default = "example"
}
variable "process_payment_lambda_uri" {
  default = "example"
}

variable "payment_notification_lambda_uri" {
  default = "example"
}

variable "lambda_role_name" {
  default = "example"
}

# variable "ssm_path_rds_username" {
#   default = "example"
# }

# variable "ssm_path_rds_password" {
#   default = "example"
# }

variable "vpc_id" {
  default = "example"
}
