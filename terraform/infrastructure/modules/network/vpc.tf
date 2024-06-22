resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_eip" "nat_gw_1" {
  vpc = true
}

resource "aws_eip" "nat_gw_2" {
  vpc = true
}


