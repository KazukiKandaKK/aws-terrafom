variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "ECS security group ID"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN"
  type        = string
}

variable "app_image" {
  description = "Docker image for app"
  type        = string
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  type        = number
  default     = 8080
}

variable "app_count" {
  description = "Number of docker containers to run"
  type        = number
  default     = 2
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  type        = number
  default     = 256
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  type        = number
  default     = 512
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 30
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secrets" {
  description = "Secrets for the container"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "enable_autoscaling" {
  description = "Enable ECS service autoscaling"
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Minimum number of running tasks"
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of running tasks"
  type        = number
  default     = 4
}

variable "autoscaling_metric_type" {
  description = "Metric to use for autoscaling (CPU or MEMORY)"
  type        = string
  default     = "CPU"
}

variable "scale_out_threshold" {
  description = "Metric threshold to trigger scale out"
  type        = number
  default     = 75
}

variable "scale_in_threshold" {
  description = "Metric threshold to trigger scale in"
  type        = number
  default     = 25
}

variable "scale_out_cooldown" {
  description = "Cooldown period after scaling out (seconds)"
  type        = number
  default     = 60
}

variable "scale_in_cooldown" {
  description = "Cooldown period after scaling in (seconds)"
  type        = number
  default     = 300
}

variable "scale_out_adjustment" {
  description = "Number of tasks to add on scale out"
  type        = number
  default     = 1
}

variable "scale_in_adjustment" {
  description = "Number of tasks to remove on scale in"
  type        = number
  default     = -1
}