# Variables for Terraform configuration - Local Services Only

variable "bucket_name" {
  description = "Name of the S3-compatible bucket in MinIO"
  type        = string
  default     = "example-demo-bucket"
}

variable "admin_ip_cidr" {
  description = "CIDR block for admin SSH access (for security rule simulation)"
  type        = string
  default     = "10.0.0.0/8"
}

# MinIO configuration variables (S3-compatible local storage)
variable "minio_endpoint" {
  description = "MinIO server endpoint URL"
  type        = string
  default     = "localhost:9000"
}

variable "minio_user" {
  description = "MinIO root user"
  type        = string
  default     = "minioadmin"
}

variable "minio_password" {
  description = "MinIO root password"
  type        = string
  default     = "minioadmin"
  sensitive   = true
}
