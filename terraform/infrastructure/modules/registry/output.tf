output "ecr_repository_url" {
  value = aws_ecr_repository.vp_repository.repository_url
}
output "ecr_name" {
  value = aws_ecr_repository.vp_repository_cicd.name
}
