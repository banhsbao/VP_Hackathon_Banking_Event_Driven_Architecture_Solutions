variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet1_cidr" {
  description = "The CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet2_cidr" {
  description = "The CIDR block for the public subnet"
  default     = "10.0.2.0/24"
}


variable "private_subnet1_cidr" {
  description = "The CIDR block for the private subnet"
  default     = "10.0.3.0/24"
}

variable "private_subnet2_cidr" {
  description = "The CIDR block for the private subnet"
  default     = "10.0.4.0/24"
}

variable "availability_zone_1" {
  description = "Availability zone for the first subnet"
  type        = string
  default     = "ap-southeast-1a"
}

variable "availability_zone_2" {
  description = "Availability zone for the second subnet"
  type        = string
  default     = "ap-southeast-1b"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}
