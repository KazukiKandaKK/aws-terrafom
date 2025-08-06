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
}

variable "certificate_arn" {
  description = "SSL certificate ARN (required for production)"
  type        = string
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

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "ip_whitelist_enabled" {
  description = "Enable IP whitelist for WAF"
  type        = bool
  default     = false
}

variable "whitelist_ips" {
  description = "List of IP addresses to whitelist"
  type        = list(string)
  default     = []
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