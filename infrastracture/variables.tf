variable "email_address" {
  description = "Your email address"
  type        = string
  default     = "youraddress@gmail.com"
}
variable "db_password" {
  description = "Your email address"
  type        = string
  default     = "dummy_password"
}
variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "eu-north-1"
}
variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "default"
}
variable "ec2_ami" {
  description = "AMI ID for EC2 instance"
  type        = string
}
variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = null
}

# Networking
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_1_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_2_cidr" {
  type    = string
  default = "10.0.4.0/24"
}

variable "availability_zone_public" {
  type = string
}

variable "availability_zone_private_1" {
  type = string
}

variable "availability_zone_private_2" {
  type = string
}

# RDS
variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_engine_version" {
  type    = string
  default = "17.4"
}

variable "avatars_bucket_name" {
  description = "S3 bucket name for avatars"
  type        = string
}
