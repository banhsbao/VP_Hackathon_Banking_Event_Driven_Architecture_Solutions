resource "aws_iam_role" "iam_role" {
  name               = var.iam_role_name
  assume_role_policy = var.assume_role_policy
  description        = var.iam_role_description
  tags = {
    Team        = "VP-DevOps"
    Name        = var.iam_role_name
    Environment = var.environment
    Terraform   = "true"
    Owner       = var.owner
  }
}
