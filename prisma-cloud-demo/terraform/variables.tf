# Variables for Terraform configuration

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "example-prisma-demo-bucket"
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
  default     = "vpc-12345678"
}

variable "admin_ip_cidr" {
  description = "CIDR block for admin SSH access"
  type        = string
  default     = "10.0.0.0/8"
}
