#--------------------------------------------------------------
# <概要>
# Terraform 初回セットアップ (Bootstrap)
# - リモートステート管理用 S3 バケットを作成（オブジェクトロック機能付き）
# - 他環境 (common / dev / prod) で利用するためのベースインフラ
#--------------------------------------------------------------

#--------------------------------------------------------------
# <実行手順>
# cd infra/bootstrap
# terraform init
# terraform plan  -var-file="terraform_bootstrap.tfvars"
# terraform apply -var-file="terraform_bootstrap.tfvars"
#--------------------------------------------------------------
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
  required_version = ">= 1.13.3"
}

#-----------------------------------------------
# AWSアカウント情報の取得
# - アカウントIDやユーザー情報を参照するために利用
#-----------------------------------------------
data "aws_caller_identity" "current" {}

#-----------------------------------------------
# 共通タグ定義
#-----------------------------------------------
locals {
  common_tags = {
    Owner       = var.owner_tag
    Environment = "terraform"
    App = var.app_identifier
  }
}

#-----------------------------------------------
# Terraform State 用の S3 バケット
#-----------------------------------------------
resource "aws_s3_bucket" "terraform_state" {
  bucket = "s3-terraform-${var.app_identifier}-${data.aws_caller_identity.current.account_id}"
  lifecycle {
    prevent_destroy = true
  }
  tags = local.common_tags
}

# 公開アクセスをブロック
resource "aws_s3_bucket_public_access_block" "terraform_state_block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3の暗号化設定
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_sse" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3バケットのオブジェクトロック設定（Terraform 1.6以降でステートロック機能を提供）
resource "aws_s3_bucket_object_lock_configuration" "terraform_state_lock" {
  bucket = aws_s3_bucket.terraform_state.id
  
  # バージョニングが有効になってからオブジェクトロックを設定
  depends_on = [aws_s3_bucket_versioning.terraform_state_versioning]

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 1
    }
  }
}

# S3バケットのバージョニング設定（オブジェクトロックに必要）
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
