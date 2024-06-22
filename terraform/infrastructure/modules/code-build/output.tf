output "vp_lambda_service_name" {
  description = "Code build service name"
  value       = aws_codebuild_project.vp_codebuid.name
}

output "code_build_arn" {
  value = aws_codebuild_project.vp_codebuid.arn
}
