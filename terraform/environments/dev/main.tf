terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  # Backend configuration is in backend.tf
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "dev"
      Project     = var.project_name
      ManagedBy   = "terraform"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}

data "aws_secretsmanager_secret_version" "db_username" {
  secret_id = "db_username"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "db_password"
}

module "vpc" {
  source = "../../modules/vpc"

  environment            = "dev"
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones    = local.availability_zones
}

module "security_groups" {
  source = "../../modules/security_groups"

  environment = "dev"
  vpc_id      = module.vpc.vpc_id
  app_port    = 8080
  db_port     = 3306
  alb_egress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ecs_egress_cidr_blocks = [module.vpc.vpc_cidr_block]
  rds_egress_cidr_blocks = [module.vpc.vpc_cidr_block]
}

module "alb" {
  source = "../../modules/alb"

  environment             = "dev"
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids
  alb_security_group_id  = module.security_groups.alb_security_group_id
  app_port               = 8080
  health_check_path      = "/health"
  certificate_arn        = var.certificate_arn
  enable_deletion_protection = false
}

module "ecs" {
  source = "../../modules/ecs"

  environment            = "dev"
  aws_region            = var.aws_region
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.security_groups.ecs_security_group_id
  target_group_arn      = module.alb.target_group_arn
  app_image             = var.app_image
  app_port              = 8080
  app_count             = 1
  fargate_cpu           = 256
  fargate_memory        = 512
  log_retention_in_days = 30

  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = "dev"
    },
    {
      name  = "DB_HOST"
      value = module.rds.db_instance_endpoint
    }
  ]

  secrets = [
    {
      name      = "DB_USERNAME"
      valueFrom = data.aws_secretsmanager_secret_version.db_username.arn
    },
    {
      name      = "DB_PASSWORD"
      valueFrom = data.aws_secretsmanager_secret_version.db_password.arn
    }
  ]
}

module "rds" {
  source = "../../modules/rds"

  environment             = "dev"
  private_subnet_ids     = module.vpc.private_subnet_ids
  rds_security_group_id  = module.security_groups.rds_security_group_id
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  max_allocated_storage  = 100
  db_name               = var.db_name
  username              = data.aws_secretsmanager_secret_version.db_username.secret_string
  password              = data.aws_secretsmanager_secret_version.db_password.secret_string
  backup_retention_period = 3
  skip_final_snapshot    = true
  deletion_protection    = false
}

module "kms" {
  source = "../../modules/kms"

  environment = "dev"
}

module "s3" {
  source = "../../modules/s3"

  environment        = "dev"
  app_name          = var.project_name
  enable_versioning = true
  log_retention_days = 30
  kms_key_arn        = module.kms.kms_key_arn
}

module "waf" {
  source = "../../modules/waf"

  environment           = "dev"
  alb_arn              = module.alb.alb_arn
  rate_limit           = 2000
  ip_whitelist_enabled = false
  log_retention_in_days = 30
}

module "ecr" {
  source = "../../modules/ecr"

  environment  = "dev"
  project_name = var.project_name
}

module "codepipeline" {
  source = "../../modules/codepipeline"

  environment           = "dev"
  project_name          = var.project_name
  aws_region           = var.aws_region
  aws_account_id       = var.aws_account_id
  ecr_repository_name  = module.ecr.repository_name
  ecs_cluster_name     = module.ecs.cluster_id
  ecs_service_name     = module.ecs.service_name
  source_bucket_name   = var.source_bucket_name
  source_object_key    = var.source_object_key
  codebuild_compute_type = "BUILD_GENERAL1_SMALL"
  log_retention_in_days = 30
  kms_key_arn           = module.kms.kms_key_arn
}