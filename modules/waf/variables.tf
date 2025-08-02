variable "environment" {
  description = "Environment name"
  type        = string
}

variable "alb_arn" {
  description = "ALB ARN to associate with WAF"
  type        = string
}

variable "rate_limit" {
  description = "Rate limit for requests per 5-minute period"
  type        = number
  default     = 2000
}

variable "ip_whitelist_enabled" {
  description = "Enable IP whitelist"
  type        = bool
  default     = false
}

variable "whitelist_ips" {
  description = "List of IP addresses to whitelist"
  type        = list(string)
  default     = []
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 30
}