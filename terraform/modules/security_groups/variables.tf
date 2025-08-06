variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 8080
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "alb_egress_cidr_blocks" {
  description = "CIDR blocks for ALB security group egress"
  type        = list(string)
}

variable "ecs_egress_cidr_blocks" {
  description = "CIDR blocks for ECS security group egress"
  type        = list(string)
}

variable "rds_egress_cidr_blocks" {
  description = "CIDR blocks for RDS security group egress"
  type        = list(string)
}