module "rds" {
  source            = "../../infrastructure/modules/rds"
  rds_identifier    = var.rds_identifier
  allocated_storage = var.allocated_storage
  aws_region        = var.aws_region
  db_username       = var.db_username
  db_engine_version = var.db_engine_version
  db_instance_class = var.db_instance_class
  db_name           = var.db_name
  db_password       = var.db_password
  db_storage_type   = var.db_storage_type
}

module "dynamo_db" {
  source              = "../../infrastructure/modules/dynamo-db"
  dynamodb_table_name = var.dynamodb_table_name
}

module "hosted_zone" {
  source      = "../../infrastructure/modules/hosted-zone"
  domain_url  = var.domain_url
  admin_email = var.admin_email
}
