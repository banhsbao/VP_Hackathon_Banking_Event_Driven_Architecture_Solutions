
output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.vp_rds.endpoint
}

output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.vp_rds.id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  value = [module.vpc.public_subnet_1_id, module.vpc.public_subnet_2_id]
}
