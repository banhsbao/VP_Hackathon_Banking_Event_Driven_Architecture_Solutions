data "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name
}

# data "aws_ssm_parameter" "ssm_rds_username" {
#   name = var.ssm_path_rds_username
# }

# data "aws_ssm_parameter" "ssm_rds_password" {
#   name            = var.ssm_path_rds_password
#   with_decryption = true
# }


data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "vp_lambda_ssg" {
  name        = format("%s-%s", var.prefix, "lambda-sg")
  description = "lambda callback handler sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "tracking lambda ingress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = format("%s-%s", var.prefix, "lambda-sg")
  }
}
