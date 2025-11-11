# Outputs for the Terraform configuration

output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.example.id
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.example.arn
}

output "security_group_id" {
  description = "ID of the created security group"
  value       = aws_security_group.example.id
}

output "iam_role_arn" {
  description = "ARN of the created IAM role"
  value       = aws_iam_role.example.arn
}
