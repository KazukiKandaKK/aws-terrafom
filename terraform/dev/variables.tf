variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "saas-app"
}

variable "app_image" {
  description = "Docker image for the application"
  type        = string
  default     = "nginx:latest"
}

variable "certificate_arn" {
  description = "SSL certificate ARN (optional)"
  type        = string
  default     = null
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "source_bucket_name" {
  description = "S3 bucket name for source code"
  type        = string
}

variable "source_object_key" {
  description = "S3 object key for source code"
  type        = string
  default     = "source.zip"
}