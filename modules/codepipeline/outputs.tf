output "codepipeline_name" {
  description = "CodePipeline name"
  value       = aws_codepipeline.app_pipeline.name
}

output "codepipeline_arn" {
  description = "CodePipeline ARN"
  value       = aws_codepipeline.app_pipeline.arn
}

output "codebuild_project_name" {
  description = "CodeBuild project name"
  value       = aws_codebuild_project.app_build.name
}

output "codebuild_project_arn" {
  description = "CodeBuild project ARN"
  value       = aws_codebuild_project.app_build.arn
}

output "artifacts_bucket_name" {
  description = "S3 artifacts bucket name"
  value       = aws_s3_bucket.codepipeline_artifacts.bucket
}

output "artifacts_bucket_arn" {
  description = "S3 artifacts bucket ARN"
  value       = aws_s3_bucket.codepipeline_artifacts.arn
}

output "codepipeline_role_arn" {
  description = "CodePipeline IAM role ARN"
  value       = aws_iam_role.codepipeline_role.arn
}

output "codebuild_role_arn" {
  description = "CodeBuild IAM role ARN"
  value       = aws_iam_role.codebuild_role.arn
}