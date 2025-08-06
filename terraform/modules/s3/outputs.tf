output "assets_bucket_id" {
  description = "Assets S3 bucket ID"
  value       = aws_s3_bucket.app_assets.id
}

output "assets_bucket_arn" {
  description = "Assets S3 bucket ARN"
  value       = aws_s3_bucket.app_assets.arn
}

output "logs_bucket_id" {
  description = "Logs S3 bucket ID"
  value       = aws_s3_bucket.app_logs.id
}

output "logs_bucket_arn" {
  description = "Logs S3 bucket ARN"
  value       = aws_s3_bucket.app_logs.arn
}

output "access_logs_bucket_id" {
  description = "S3 access logs bucket ID"
  value       = aws_s3_bucket.access_logs.id
}

output "access_logs_bucket_arn" {
  description = "S3 access logs bucket ARN"
  value       = aws_s3_bucket.access_logs.arn
}

output "s3_access_role_arn" {
  description = "S3 access role ARN"
  value       = aws_iam_role.s3_access_role.arn
}