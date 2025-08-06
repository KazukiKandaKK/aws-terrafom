variable "environment" {
  description = "Environment name"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning for assets"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain logs in S3"
  type        = number
  default     = 90
}
variable "kms_key_arn" {
  description = "ARN of the KMS key for bucket encryption"
  type        = string
}
