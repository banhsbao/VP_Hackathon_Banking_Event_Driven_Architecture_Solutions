resource "aws_codepipeline" "vp_codepipeline" {
  name     = "vp-codepipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = var.codepipeline_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = var.code_connection_arn
        FullRepositoryId = var.full_repository_id
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      version          = "1"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = var.vp_lambda_service_name
      }
    }
  }
}
