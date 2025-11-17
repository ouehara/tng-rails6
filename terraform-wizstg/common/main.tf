#-----------------------------------------------
# 共通インフラの構築 (ECR, IAM, OIDC など)
# 環境 (dev, prod) 共通リソースを定義
#-----------------------------------------------

#-----------------------------------------------
# 実行手順
# cd infra/common
# terraform init
# terraform plan -var-file="terraform_common.tfvars"
# terraform apply -var-file="terraform_common.tfvars"
# -----------------------------------------------
# 20251001
# Plan: 5 to add, 0 to change, 0 to destroy.
#
# 20251026 wizstg削除後に再作成した
#
#-----------------------------------------------
provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.14.1"
    }
  }
  backend "s3" {
    # TODO 作成したS3バケット名をハードコートしてください。
    bucket         = "s3-terraform-w-rails-1026-904271084068" # TODO 作成したS3バケット名をハードコートしてください。

    key            = "common/terraform.tfstate"  # 環境ごとに異なる

    # TODO リージョンを指定してください
    region         = "ap-northeast-1" # TODO 作成したS3バケット名をハードコートしてください。

    encrypt        = true
  }
  required_version = ">= 1.13.3"
}

#-----------------------------------------------
# AWSアカウント情報の取得
# - アカウントIDやユーザー情報を参照するために利用
data "aws_caller_identity" "current" {}
#-----------------------------------------------

#-----------------------------------------------
# 共通タグ定義
#-----------------------------------------------
locals {
  common_tags = {
    Owner       = var.owner_tag
    Environment = "common"
    App         = var.app_identifier
  }
  aws_region = var.aws_region
  aws_region_string = replace(var.aws_region, "-", "")  #リージョン名をハイフン無しで整形
  ecr_repository_name = "ecr-${var.app_identifier}-${local.aws_region_string}"
  finger_print = var.oidc_finger_print
  github_owner= var.github_owner
  github_repo= var.github_repo
}

#-----------------------------------------------
# 共通 ECR リポジトリ
#-----------------------------------------------
resource "aws_ecr_repository" "app_ecr" {
  name = local.ecr_repository_name

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.common_tags
}

#-----------------------------------------------
# GitHub Actions 用 OIDC プロバイダー
#-----------------------------------------------
resource "aws_iam_openid_connect_provider" "github_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [local.finger_print]
  tags = local.common_tags
}

# #-----------------------------------------------
# # GitHub Actions 用 IAM ロール
# #-----------------------------------------------
resource "aws_iam_role" "github_actions_role" {
  name = "${var.app_identifier}-GitHubActionsOIDCRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github_oidc.arn
      },
      Action    = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        "StringEquals" = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        },
        "StringLike" = {
          "token.actions.githubusercontent.com:sub" = "repo:${local.github_owner}/${local.github_repo}:*"
        }
      }
    }]
  })
}

#-----------------------------------------------
# GitHub Actions 用 ECR Push ポリシー
#-----------------------------------------------
resource "aws_iam_policy" "github_actions_ecr_push_ecs_deploy_policy" {
  name        = "${var.app_identifier}-GitHubActionsECRPushAndECSDeployPolicy"
  description = "GitHub Actions が ECR に Push & 全ての ECS サービスを再デプロイするためのポリシー"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # ECR ログイン
      {
        Sid    = "ECRLogin"
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      # ECR Push/Pull
      {
        Sid    = "ECRPushPull"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = "arn:aws:ecr:${local.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${local.ecr_repository_name}"
      },
      # ECS サービス更新（すべてのサービスを対象）
      {
        Sid    = "ECSUpdateServiceAll"
        Effect = "Allow"
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ]
        Resource = "arn:aws:ecs:${local.aws_region}:${data.aws_caller_identity.current.account_id}:service/*"
      }
    ]
  })
}


# #-----------------------------------------------
# # IAM ロールに ECR Push ポリシーをアタッチ
# #-----------------------------------------------
resource "aws_iam_role_policy_attachment" "github_actions_ecr_push" {
  role       = aws_iam_role.github_actions_role.id
  policy_arn = aws_iam_policy.github_actions_ecr_push_ecs_deploy_policy.arn
}
