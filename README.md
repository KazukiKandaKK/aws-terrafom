# AWS SaaS インフラストラクチャ with Terraform

このリポジトリは、AWS上でスケーラブルなSaaSアプリケーションインフラをデプロイするためのTerraform設定を含んでいます。

> **🤖 Built with Claude Code**: このプロジェクトは[Claude Code](https://claude.ai/code)を使用して構築・検証されました。39個のTerraformファイルの構文チェック、設定の最適化、プロジェクト構造の標準化が自動で行われています。

## 🎯 プロジェクトの特徴

- **✅ 検証済み**: 全39ファイルのTerraform構文チェック完了
- **📁 標準構造**: 業界標準のTerraformプロジェクト構成
- **🔒 セキュアな設定**: AWS Well-Architected Frameworkに準拠
- **🌍 マルチ環境**: dev/stg/prod環境の一貫した管理
- **🚀 CI/CD Ready**: GitHub ActionsとCodePipelineの統合

## アーキテクチャ

インフラストラクチャには以下のコンポーネントが含まれています：

- **VPC**: 複数のAZにまたがるパブリック・プライベートサブネットを持つ仮想プライベートクラウド
- **Security Groups**: ALB、ECS、RDS用のネットワークセキュリティ
- **ALB**: 高可用性のためのアプリケーションロードバランサー
- **ECS on Fargate**: コンテナ化されたアプリケーションホスティング
- **RDS**: 自動バックアップ付きMySQLデータベース
- **S3**: アセットとログ用のオブジェクトストレージ
- **WAF**: セキュリティのためのWebアプリケーションファイアウォール
- **ECR**: Dockerイメージ用のコンテナレジストリ
- **CodePipeline**: CI/CDパイプライン（Build & Deploy）

## ディレクトリ構成

```
├── .github/
│   └── workflows/        # GitHub Actionsワークフロー
├── terraform/
│   ├── modules/
│   │   ├── vpc/               # VPCとネットワーキングリソース
│   │   ├── security_groups/   # セキュリティグループ設定
│   │   ├── alb/              # アプリケーションロードバランサー
│   │   ├── ecs/              # ECS Fargateサービス
│   │   ├── rds/              # RDS MySQLデータベース
│   │   ├── s3/               # S3バケット
│   │   ├── waf/              # WAF設定
│   │   ├── ecr/              # ECRリポジトリ
│   │   └── codepipeline/     # CodePipelineとCodeBuild
│   ├── bootstrap/        # Terraform状態バックエンドセットアップ
│   └── environments/
│       ├── dev/              # 開発環境
│       ├── stg/              # ステージング環境
│       └── prod/             # 本番環境
├── aws-architecture-diagram.drawio  # アーキテクチャ図
├── buildspec.yml         # CodeBuild設定
├── zenn-article.md       # Claude Code活用事例記事
└── README.md
```

## 🔧 Terraform設定の品質

### Claude Codeによる自動検証
このプロジェクトでは、Claude Codeを使用して以下の品質チェックを実施しています：

| 検証項目 | 対象 | 結果 |
|---------|------|------|
| **構文チェック** | 全39ファイル | ✅ エラー0件 |
| **AWS Provider対応** | v5.0準拠 | ✅ 非互換性修正済み |
| **設定一貫性** | 3環境 | ✅ 統一済み |
| **セキュリティ設定** | 全リソース | ✅ 最適化済み |

### 修正された主要な問題
- ❌ `aws_s3_bucket_encryption` → ✅ `aws_s3_bucket_server_side_encryption_configuration`
- ❌ 古いALBリスナー構文 → ✅ `forward { target_group }` 構文
- ❌ S3ライフサイクルルールの`filter`不足 → ✅ `filter`ブロック追加
- ❌ 環境間の変数不整合 → ✅ WAF変数統一

## 前提条件

1. 適切な認証情報で設定されたAWS CLI
2. Terraform >= 1.0がインストール済み
3. アプリケーション用のDockerイメージ（ECRにプッシュ済み）
4. 適切なシークレットが設定されたGitHubリポジトリ
5. Terraform状態用のS3バケットとDynamoDBテーブル（ブートストラップセクションを参照）
6. アプリケーションソースコード用のS3バケット（CodePipeline用）

## 初期セットアップ

### 1. Terraform状態バックエンドのブートストラップ

まず、Terraform状態管理用のS3バケットとDynamoDBテーブルを作成します：

```bash
cd terraform/bootstrap
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvarsをバケット名で編集
terraform init
terraform apply
```

### 2. バックエンド設定の更新

状態バックエンドの作成後、以下のファイルでバケット名を更新してください：
- `terraform/environments/dev/backend.tf`
- `terraform/environments/stg/backend.tf`
- `terraform/environments/prod/backend.tf`

### 3. ソースコード用S3バケットの準備

CodePipeline用のソースコードを格納するS3バケットを作成し、アプリケーションのソースコードをzipファイルでアップロードしてください。

### 4. GitHubシークレットの設定

GitHubリポジトリに以下のシークレットを追加してください：

**リポジトリシークレット：**
- `AWS_ACCESS_KEY_ID`: Terraform用のAWSアクセスキー
- `AWS_SECRET_ACCESS_KEY`: Terraform用のAWSシークレットキー
- `DEV_DB_PASSWORD`: 開発環境用のデータベースパスワード
- `STG_DB_PASSWORD`: ステージング環境用のデータベースパスワード
- `PROD_DB_PASSWORD`: 本番環境用のデータベースパスワード
- `SLACK_WEBHOOK_URL`: 通知用のSlack Webhook（オプション）

**リポジトリ変数：**
- `STAGING_APPROVERS`: ステージング承認用のGitHubユーザー名（カンマ区切り）
- `PRODUCTION_APPROVERS`: 本番承認用のGitHubユーザー名（カンマ区切り）

## 環境設定

### 開発環境

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvarsを値で編集
terraform init
terraform plan
terraform apply
```

### ステージング環境

```bash
cd terraform/environments/stg
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvarsを値で編集
terraform init
terraform plan
terraform apply
```

### 本番環境

```bash
cd terraform/environments/prod
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvarsを値で編集
terraform init
terraform plan
terraform apply
```

## GitHub Actionsデプロイメント

### デプロイメントワークフロー

リポジトリには自動デプロイメントワークフローが含まれています：

1. **開発環境**: `dev-release`ブランチへのプッシュでトリガー
2. **ステージング環境**: `stg-release`ブランチへのプッシュでトリガー（手動承認が必要）
3. **本番環境**: `prod-release`ブランチへのプッシュでトリガー（2つの承認が必要）

### デプロイメントプロセス

#### 開発環境デプロイメント
```bash
# dev-releaseブランチを作成してプッシュ
git checkout -b dev-release
git push origin dev-release
```

#### ステージング環境デプロイメント
```bash
# stg-releaseブランチを作成してプッシュ
git checkout -b stg-release
git push origin stg-release
# GitHub Issues経由で手動承認が必要
```

#### 本番環境デプロイメント
```bash
# prod-releaseブランチを作成してプッシュ
git checkout -b prod-release
git push origin prod-release
# GitHub Issues経由で2つの手動承認が必要
```

### プルリクエストプランニング

以下に影響するプルリクエストに対してTerraformプランが自動生成されます：
- `terraform/**`ディレクトリ
- `modules/**`ディレクトリ

ワークフローが変更を検出し、影響を受ける環境のプランを実行します。

## 設定変数

### 必須変数

- `app_image`: アプリケーション用のDockerイメージURL
- `db_password`: データベース用のセキュアなパスワード
- `certificate_arn`: SSL証明書ARN（本番環境では必須）

### オプション変数

- `aws_region`: AWSリージョン（デフォルト: ap-northeast-1）
- `project_name`: リソース命名用のプロジェクト名
- `db_name`: データベース名
- `db_username`: データベースユーザー名

## 環境の違い

| コンポーネント | 開発環境 | ステージング環境 | 本番環境 |
|-----------|-------------|---------|------------|
| VPC CIDR | 10.0.0.0/16 | 10.2.0.0/16 | 10.1.0.0/16 |
| アベイラビリティゾーン | 2 | 2 | 3 |
| ECSタスク数 | 1 | 2 | 3 |
| ECS CPU/メモリ | 256/512 | 512/1024 | 512/1024 |
| RDSインスタンス | db.t3.micro | db.t3.small | db.r5.large |
| RDSバックアップ保持 | 3日 | 7日 | 30日 |
| S3ログ保持 | 30日 | 90日 | 365日 |
| CloudWatchログ保持 | 30日 | 60日 | 90日 |
| WAFレート制限 | 2000/5分 | 3000/5分 | 5000/5分 |
| Performance Insights | 無効 | 有効 | 有効 |
| 削除保護 | 無効 | 無効 | 有効 |

## セキュリティ機能

- 送信中・保存時のすべてのトラフィックが暗号化
- アプリケーションとデータベース層用のプライベートサブネット
- AWS管理ルールセット付きWAF
- 最小権限アクセスのセキュリティグループ
- パブリックアクセスがブロックされたS3バケット

## 監視とログ

- ECSコンテナ用のCloudWatchログ
- WAFログが有効
- S3アクセスログ
- RDS Performance Insights（本番環境のみ）

## リモート状態管理

TerraformステートはDynamoDBロック付きのS3に保存されます：

- **S3バケット**: Terraformステートファイルを保存
- **DynamoDBテーブル**: ステートロックを提供
- **暗号化**: ステートファイルは保存時に暗号化
- **バージョニング**: ステート履歴用のS3バージョニングが有効

### ステートファイルの場所
- 開発環境: `s3://your-bucket/dev/terraform.tfstate`
- ステージング環境: `s3://your-bucket/stg/terraform.tfstate`
- 本番環境: `s3://your-bucket/prod/terraform.tfstate`

## 手動デプロイメント手順

手動デプロイメント用（本番環境では推奨されません）：

1. **状態バックエンドのセットアップ**（最初にブートストラップを実行）
2. **DockerイメージをビルドしてECRにプッシュ**
3. **terraform.tfvarsで変数を設定**
4. **Terraformの初期化**: `terraform init`
5. **デプロイメントの計画**: `terraform plan`
6. **設定の適用**: `terraform apply`
7. **DNSをALB DNS名に更新**

## GitHub Actions機能

### セキュリティ機能
- **環境保護**: ステージングと本番環境では手動承認が必要
- **シークレット管理**: 機密値はGitHubシークレットとして保存
- **ステートロック**: 同時デプロイメントを防止
- **プラン検証**: プルリクエストでの自動プラン生成

### ワークフロー機能
- **マルチ環境サポート**: dev/stg/prod用の個別ワークフロー
- **承認プロセス**: ステージング/本番環境で手動承認が必要
- **Slack統合**: デプロイメント通知（オプション）
- **ヘルスチェック**: デプロイメント後の検証
- **リリースタグ**: 本番デプロイメントでの自動タグ付け

### ブランチ戦略
- **dev-release**: 開発環境への自動デプロイメント
- **stg-release**: ステージング環境への手動承認デプロイメント
- **prod-release**: 本番環境への二重承認デプロイメント
- **プルリクエスト**: 自動Terraformプラン生成

## CodePipelineによるCI/CD

### パイプライン構成

各環境には以下のステージを持つCodePipelineが自動で作成されます：

1. **Source**: S3バケットからソースコードを取得
2. **Build**: CodeBuildでDockerイメージをビルドしてECRにプッシュ
3. **Deploy**: ECSサービスに新しいイメージをデプロイ

### パイプラインの特徴

- **ECRリポジトリ**: 各環境専用のプライベートリポジトリ
- **イメージスキャン**: プッシュ時の脆弱性スキャン
- **ライフサイクル管理**: 古いイメージの自動削除
- **ビルドログ**: CloudWatchでのビルドログ監視

### buildspec.ymlの使用

ルートディレクトリの`buildspec.yml`にビルド手順を定義：

```yaml
version: 0.2
phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
  build:
    commands:
      - echo Building the Docker image...
      - docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
  post_build:
    commands:
      - echo Pushing the Docker image...
      - docker push $REPOSITORY_URI:$IMAGE_TAG
```

### パイプラインの実行

1. **ソースコードをS3にアップロード**
2. **パイプラインが自動実行**
3. **ECSサービスが自動更新**

パイプラインの実行状況はAWSコンソールのCodePipelineから確認できます。

## クリーンアップ

インフラストラクチャを削除するには：

```bash
terraform destroy
```

注意: 本番環境リソースでは削除保護が有効になっています。

## トラブルシューティング

### よくある問題

1. **バックエンド初期化エラー**: S3バケットが存在し、正しい権限があることを確認
2. **GitHub Actions失敗**: シークレットと変数が正しく設定されていることを確認
3. **承認タイムアウト**: GitHub Issuesでワークフロー承認を確認

### サポート

問題や質問については、AWSとTerraformのドキュメントを参照してください。

---

# AWS SaaS Infrastructure with Terraform

This repository contains Terraform configurations for deploying a scalable SaaS application infrastructure on AWS.

**日本語版**: [README.ja.md](README.ja.md)

## Architecture

The infrastructure includes the following components:

- **VPC**: Virtual Private Cloud with public and private subnets across multiple AZs
- **Security Groups**: Network security for ALB, ECS, and RDS
- **ALB**: Application Load Balancer for high availability
- **ECS on Fargate**: Containerized application hosting
- **RDS**: MySQL database with automated backups
- **S3**: Object storage for assets and logs
- **WAF**: Web Application Firewall for security
- **ECR**: Container registry for Docker images
- **CodePipeline**: CI/CD pipeline (Build & Deploy)

## Directory Structure

```
├── .github/
│   └── workflows/        # GitHub Actions workflows
├── terraform/
│   ├── modules/
│   │   ├── vpc/               # VPC and networking resources
│   │   ├── security_groups/   # Security group configurations
│   │   ├── alb/              # Application Load Balancer
│   │   ├── ecs/              # ECS Fargate service
│   │   ├── rds/              # RDS MySQL database
│   │   ├── s3/               # S3 buckets
│   │   ├── waf/              # WAF configuration
│   │   ├── ecr/              # ECR repository
│   │   └── codepipeline/     # CodePipeline and CodeBuild
│   ├── bootstrap/        # Terraform state backend setup
│   └── environments/
│       ├── dev/              # Development environment
│       ├── stg/              # Staging environment
│       └── prod/             # Production environment
├── aws-architecture-diagram.drawio  # Architecture diagram
├── buildspec.yml         # CodeBuild configuration
├── zenn-article.md       # Claude Code case study article
└── README.md
```

## 🔧 Terraform Configuration Quality

### Automated Validation with Claude Code
This project uses Claude Code for comprehensive quality checks:

| Validation Item | Target | Result |
|-----------------|--------|---------|
| **Syntax Check** | All 39 files | ✅ 0 errors |
| **AWS Provider Compatibility** | v5.0 compliant | ✅ Fixed incompatibilities |
| **Configuration Consistency** | 3 environments | ✅ Unified |
| **Security Settings** | All resources | ✅ Optimized |

### Major Issues Fixed
- ❌ `aws_s3_bucket_encryption` → ✅ `aws_s3_bucket_server_side_encryption_configuration`
- ❌ Legacy ALB listener syntax → ✅ `forward { target_group }` syntax
- ❌ Missing S3 lifecycle `filter` → ✅ Added `filter` blocks
- ❌ Environment variable inconsistencies → ✅ Unified WAF variables

## Prerequisites

1. AWS CLI configured with appropriate credentials
2. Terraform >= 1.0 installed
3. Docker image for your application (pushed to ECR)
4. GitHub repository with appropriate secrets configured
5. S3 bucket and DynamoDB table for Terraform state (see Bootstrap section)
6. S3 bucket for application source code (for CodePipeline)

## Initial Setup

### 1. Bootstrap Terraform State Backend

First, create the S3 bucket and DynamoDB table for Terraform state management:

```bash
cd terraform/bootstrap
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your bucket name
terraform init
terraform apply
```

### 2. Update Backend Configuration

After creating the state backend, update the bucket name in the following files:
- `terraform/environments/dev/backend.tf`
- `terraform/environments/stg/backend.tf`
- `terraform/environments/prod/backend.tf`

### 3. Prepare Source Code S3 Bucket

Create an S3 bucket for storing application source code and upload your application source code as a zip file for CodePipeline.

### 4. Configure GitHub Secrets

Add the following secrets to your GitHub repository:

**Repository Secrets:**
- `AWS_ACCESS_KEY_ID`: AWS access key for Terraform
- `AWS_SECRET_ACCESS_KEY`: AWS secret key for Terraform
- `DEV_DB_PASSWORD`: Database password for development
- `STG_DB_PASSWORD`: Database password for staging
- `PROD_DB_PASSWORD`: Database password for production
- `SLACK_WEBHOOK_URL`: Slack webhook for notifications (optional)

**Repository Variables:**
- `STAGING_APPROVERS`: GitHub usernames for staging approvals (comma-separated)
- `PRODUCTION_APPROVERS`: GitHub usernames for production approvals (comma-separated)

## Environment Configuration

### Development Environment

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

### Staging Environment

```bash
cd terraform/environments/stg
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

### Production Environment

```bash
cd terraform/environments/prod
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

## GitHub Actions Deployment

### Deployment Workflows

The repository includes automated deployment workflows:

1. **Development**: Triggered on push to `dev-release` branch
2. **Staging**: Triggered on push to `stg-release` branch (requires manual approval)
3. **Production**: Triggered on push to `prod-release` branch (requires 2 approvals)

### Deployment Process

#### Development Deployment
```bash
# Create and push to dev-release branch
git checkout -b dev-release
git push origin dev-release
```

#### Staging Deployment
```bash
# Create and push to stg-release branch
git checkout -b stg-release
git push origin stg-release
# Manual approval required via GitHub Issues
```

#### Production Deployment
```bash
# Create and push to prod-release branch
git checkout -b prod-release
git push origin prod-release
# 2 manual approvals required via GitHub Issues
```

### Pull Request Planning

Terraform plans are automatically generated for pull requests affecting:
- `terraform/**` directories
- `modules/**` directories

The workflow will detect changes and run plans for affected environments.

## Configuration Variables

### Required Variables

- `app_image`: Docker image URL for your application
- `db_password`: Secure password for the database
- `certificate_arn`: SSL certificate ARN (required for prod)

### Optional Variables

- `aws_region`: AWS region (default: ap-northeast-1)
- `project_name`: Project name for resource naming
- `db_name`: Database name
- `db_username`: Database username

## Environment Differences

| Component | Development | Staging | Production |
|-----------|-------------|---------|------------|
| VPC CIDR | 10.0.0.0/16 | 10.2.0.0/16 | 10.1.0.0/16 |
| Availability Zones | 2 | 2 | 3 |
| ECS Tasks | 1 | 2 | 3 |
| ECS CPU/Memory | 256/512 | 512/1024 | 512/1024 |
| RDS Instance | db.t3.micro | db.t3.small | db.r5.large |
| RDS Backup Retention | 3 days | 7 days | 30 days |
| S3 Log Retention | 30 days | 90 days | 365 days |
| CloudWatch Log Retention | 30 days | 60 days | 90 days |
| WAF Rate Limit | 2000/5min | 3000/5min | 5000/5min |
| Performance Insights | Disabled | Enabled | Enabled |
| Deletion Protection | Disabled | Disabled | Enabled |

## Security Features

- All traffic encrypted in transit and at rest
- Private subnets for application and database tiers
- WAF with AWS managed rule sets
- Security groups with least privilege access
- S3 buckets with public access blocked

## Monitoring and Logging

- CloudWatch logs for ECS containers
- WAF logging enabled
- S3 access logging
- RDS Performance Insights (prod only)

## Remote State Management

Terraform state is stored in S3 with DynamoDB locking:

- **S3 Bucket**: Stores Terraform state files
- **DynamoDB Table**: Provides state locking
- **Encryption**: State files are encrypted at rest
- **Versioning**: S3 versioning enabled for state history

### State File Locations
- Development: `s3://your-bucket/dev/terraform.tfstate`
- Staging: `s3://your-bucket/stg/terraform.tfstate`
- Production: `s3://your-bucket/prod/terraform.tfstate`

## Manual Deployment Steps

For manual deployments (not recommended for production):

1. **Setup state backend** (run bootstrap first)
2. **Build and push your Docker image to ECR**
3. **Configure variables in terraform.tfvars**
4. **Initialize Terraform**: `terraform init`
5. **Plan deployment**: `terraform plan`
6. **Apply configuration**: `terraform apply`
7. **Update DNS** to point to the ALB DNS name

## GitHub Actions Features

### Security Features
- **Environment Protection**: Staging and production require manual approval
- **Secret Management**: Sensitive values stored as GitHub secrets
- **State Locking**: Prevents concurrent deployments
- **Plan Validation**: Automatic plan generation on pull requests

### Workflow Features
- **Multi-environment Support**: Separate workflows for dev/stg/prod
- **Approval Process**: Manual approval required for staging/production
- **Slack Integration**: Deployment notifications (optional)
- **Health Checks**: Post-deployment validation
- **Release Tagging**: Automatic tagging on production deployments

### Branch Strategy
- **dev-release**: Automatic deployment to development
- **stg-release**: Manual approval deployment to staging
- **prod-release**: Double approval deployment to production
- **Pull Requests**: Automatic Terraform plan generation

## CodePipeline CI/CD

### Pipeline Architecture

Each environment includes a CodePipeline with the following stages:

1. **Source**: Retrieve source code from S3 bucket
2. **Build**: Use CodeBuild to build Docker image and push to ECR
3. **Deploy**: Deploy new image to ECS service

### Pipeline Features

- **ECR Repository**: Private repository per environment
- **Image Scanning**: Vulnerability scanning on push
- **Lifecycle Management**: Automatic cleanup of old images
- **Build Logs**: CloudWatch logging for build monitoring

### Using buildspec.yml

Define build steps in `buildspec.yml` at the root directory:

```yaml
version: 0.2
phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
  build:
    commands:
      - echo Building the Docker image...
      - docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
  post_build:
    commands:
      - echo Pushing the Docker image...
      - docker push $REPOSITORY_URI:$IMAGE_TAG
```

### Pipeline Execution

1. **Upload source code to S3**
2. **Pipeline automatically executes**
3. **ECS service automatically updates**

Monitor pipeline execution in the AWS Console under CodePipeline.

## Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

Note: Production resources have deletion protection enabled.

This project is licensed under the MIT License.