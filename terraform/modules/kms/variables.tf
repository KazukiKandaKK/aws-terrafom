variable "environment" {
  description = "Environment name"
  type        = string
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
  default     = "CMK for S3 encryption"
}
