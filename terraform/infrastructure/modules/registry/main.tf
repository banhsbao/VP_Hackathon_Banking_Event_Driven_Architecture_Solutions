resource "aws_ecr_repository" "vp_repository" {
  name                 = "vp-ecr-10"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "vp_repository_cicd" {
  name                 = "vp-ecr-10-cicd-serverless"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
