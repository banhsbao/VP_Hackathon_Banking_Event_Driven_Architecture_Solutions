variable "aws_region" {
  description = "The name of the aws region"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  default     = "postgres"
}

variable "db_storage_type" {
  description = "The name of db storage type"
  default     = "gp2"
}


variable "db_username" {
  description = "The database master username"
  default     = "admin"
}

variable "db_password" {
  description = "The database master password"
  default     = "password123"
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  default     = 20
}

variable "db_engine_version" {
  description = "The version of PostgreSQL to use"
  default     = "13.3"
}

variable "rds_identifier" {
  type = string
}
