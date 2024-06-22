resource "aws_codestarconnections_connection" "code_connection" {
  name          = "github-bh-connection"
  provider_type = "GitHub"
}
