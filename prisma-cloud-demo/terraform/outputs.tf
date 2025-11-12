# Outputs for the Terraform configuration - Local Services

output "bucket_name" {
  description = "Name of the created MinIO bucket"
  value       = minio_s3_bucket.example.bucket
}

output "bucket_endpoint" {
  description = "MinIO bucket endpoint"
  value       = "http://${var.minio_endpoint}/${minio_s3_bucket.example.bucket}"
}

output "minio_console" {
  description = "MinIO Console URL"
  value       = "http://localhost:9001"
}

output "iam_policy_simulated" {
  description = "Simulated IAM policy (local only)"
  value       = "Policy created locally - see null_resource.example_policy"
}

output "security_rules_simulated" {
  description = "Simulated security rules (local only)"
  value       = "Security rules created locally - see null_resource.security_rules"
}
