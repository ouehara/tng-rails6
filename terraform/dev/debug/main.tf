#-----------------------------------------------
# <実行方法>
#
# cd ../dev
# terraform init
# terraform plan -var-file="../terraform_d2cxstg.tfvars"
# terraform apply -var-file="../terraform_d2cxstg.tfvars"
#-----------------------------------------------
# terraform plan -var-file="../terraform_wizstg.tfvars"
# terraform apply -var-file="../terraform_wizstg.tfvars"
#
# 20251001
# Plan: 22 to add, 0 to change, 0 to destroy.
#
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
    bucket = "s3-terraform-v-rails-1001-412742703218"
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
    bucket = "s3-terraform-v-rails-1001-412742703218"
    key    = "dev/terraform.tfstate"
    region = "ap-northeast-1"
  }
}