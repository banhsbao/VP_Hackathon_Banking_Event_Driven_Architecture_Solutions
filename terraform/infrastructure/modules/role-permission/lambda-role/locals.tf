locals {
  project        = "vp"
  domain_name    = var.domain_name
  app_prefix     = "${var.environment}-${local.project}"
  admin_email    = "chaubao.cloud@gmail.com"
  s3_domain_name = local.domain_name
}
