# Sample Terraform configuration for Prisma Cloud scanning
# This demonstrates common infrastructure resources using local services
# No cloud credentials required - runs entirely with local Docker services

terraform {
  required_version = ">= 1.0"
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "~> 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "minio" {
  minio_server   = var.minio_endpoint
  minio_user     = var.minio_user
  minio_password = var.minio_password
  minio_ssl      = false
}

# MinIO Bucket with versioning (S3-compatible local storage)
resource "minio_s3_bucket" "example" {
  bucket = var.bucket_name
  acl    = "private"
}

# Enable versioning for the bucket
resource "minio_s3_bucket" "example_versioned" {
  bucket        = "${var.bucket_name}-versioned"
  acl           = "private"
  force_destroy = true
}

# Local IAM Policy simulation using null resource
# This demonstrates IAM policy structure without requiring cloud services
resource "null_resource" "example_policy" {
  triggers = {
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:ListBucket"
          ]
          Resource = [
            "arn:minio:s3:::${var.bucket_name}",
            "arn:minio:s3:::${var.bucket_name}/*"
          ]
        }
      ]
    })
  }

  provisioner "local-exec" {
    command = "echo 'IAM Policy created (simulated locally)'"
  }
}

# Local security rules simulation
resource "null_resource" "security_rules" {
  triggers = {
    security_config = jsonencode({
      name        = "example-security-rules"
      description = "Example security rules with restricted access"
      ingress = [
        {
          description = "SSH from specific IP"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [var.admin_ip_cidr]
        },
        {
          description = "HTTPS"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress = [
        {
          description = "All outbound traffic"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    })
  }

  provisioner "local-exec" {
    command = "echo 'Security rules created (simulated locally)'"
  }
}
