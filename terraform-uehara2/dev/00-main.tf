#-----------------------------------------------
# devインフラの構築 (NW,DB,ECS)
# 環境 (dev, prod) リソースを定義
#-----------------------------------------------

#-----------------------------------------------
# <実行方法>
# ```
# cd ../dev
# terraform init
# terraform plan -var-file="terraform_dev.tfvars"
# terraform apply -var-file="terraform_dev.tfvars"
# ```
#-----------------------------------------------
# 20251026 wizstg削除後に施策正

# メインプロバイダー（デフォルト）
provider "aws" {
  region = var.aws_region
}

# CloudFront WAF用のus-east-1プロバイダー
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.14.1"
      configuration_aliases = [aws.us_east_1]
    }
  }
  backend "s3" {
    # TODO 作成したS3バケット名をハードコートしてください。
    bucket         = "s3-terraform-w-rails-1026-904271084068"

    key            = "dev/terraform.tfstate"  # 環境ごとに異なる

    # TODO リージョンを指定してください
    region         = "ap-northeast-1"

    encrypt        = true
  }
  required_version = ">= 1.13.3"
}

#-----------------------------------------------
# 共通リソースの状態 (`common/` から取得)
# `terraform_remote_state` を利用して、共通の AWS 設定を取得
#-----------------------------------------------
data "terraform_remote_state" "common" {
  backend = "s3"
  config = {
    # TODO `common/` で作成したS3バケット名をハードコートしてください。
    bucket = "s3-terraform-w-rails-1026-904271084068"

    key    = "common/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

#-----------------------------------------------
# ローカル変数の設定 (`common/` のデータを適用)
#-----------------------------------------------
locals {
  common_tags = {
    Owner       = var.owner_tag
    Environment = var.environment
    App         = var.app_identifier
  }
  aws_region = var.aws_region
  aws_region_string = "apn1"  #リージョン名をハイフン無しで整形
  app_identifier = var.app_identifier
  environment = var.environment
  availability_zones = var.availability_zones
  ecr_repository_url = data.terraform_remote_state.common.outputs.ecr_repository_url
}
