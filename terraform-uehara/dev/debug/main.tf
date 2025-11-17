#-----------------------------------------------
# <実行方法>
# ```
# terraform init
# terraform plan -var-file="../terraform_dev.tfvars"
#
# #取り込み
# terraform init
# terraform refresh -var-file="../terraform_dev.tfvars"
# ```
#-----------------------------------------------

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.14.1"
    }
  }
  backend "s3" {
    bucket = "s3-terraform-x-rails-0928-113434362347"
    key    = "dev/debug/terraform.tfstate"
    region = "ap-northeast-1"
    encrypt = true
  }
}

# Provider configuration
provider "aws" {
  region = var.aws_region
}

#-----------------------------------------------
# Dev environment remote state reference
# dev直下のリソースを参照するための設定
#-----------------------------------------------
data "terraform_remote_state" "dev" {
  backend = "s3"
  config = {
    bucket = "s3-terraform-x-rails-0928-113434362347"
    key    = "dev/terraform.tfstate"
    region = "ap-northeast-1"
  }
}