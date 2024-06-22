module "vpc" {
  source               = "../network"
  vpc_cidr_block       = "10.0.0.0/16"
  public_subnet1_cidr  = "10.0.1.0/24"
  public_subnet2_cidr  = "10.0.2.0/24"
  private_subnet1_cidr = "10.0.3.0/24"
  private_subnet2_cidr = "10.0.4.0/24"
  availability_zone_1  = "ap-southeast-1a"
  availability_zone_2  = "ap-southeast-1b"
  region               = var.aws_region
}

resource "aws_security_group" "rds_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_db_parameter_group" "rds_custom_group" {
  name   = "my-pg"
  family = "postgres13"
  parameter {
    apply_method = "immediate"
    name         = "rds.force_ssl"
    value        = "0"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [module.vpc.public_subnet_1_id, module.vpc.public_subnet_2_id]

  tags = {
    Name = "main-db-subnet-group"
  }
}

resource "aws_db_instance" "vp_rds" {
  identifier             = var.rds_identifier
  allocated_storage      = var.allocated_storage
  storage_type           = var.db_storage_type
  engine                 = "postgres"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = true
  tags = {
    Name = "MyRDSInstance"
  }
}
