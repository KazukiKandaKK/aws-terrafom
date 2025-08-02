output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.db_instance_endpoint
  sensitive   = true
}

output "assets_bucket_name" {
  description = "Assets S3 bucket name"
  value       = module.s3.assets_bucket_id
}

output "logs_bucket_name" {
  description = "Logs S3 bucket name"
  value       = module.s3.logs_bucket_id
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_id
}

output "waf_web_acl_arn" {
  description = "WAF Web ACL ARN"
  value       = module.waf.web_acl_arn
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "codepipeline_name" {
  description = "CodePipeline name"
  value       = module.codepipeline.codepipeline_name
}