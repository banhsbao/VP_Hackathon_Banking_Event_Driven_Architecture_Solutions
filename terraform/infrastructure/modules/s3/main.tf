resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "vp-codepipeline-bucket-2"
  tags = {
    Name        = "vp-codepipeline-bucket"
    Environment = "Dev"
  }
}
