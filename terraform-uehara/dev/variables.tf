# AWS のリージョン
variable "aws_region" {
  description = "AWSのリージョン"
  type        = string
  default     = "ap-northeast-1"
}

# アプリケーション識別子 (システム名など)
variable "app_identifier" {
  description = "アプリケーションの識別子"
  type        = string
  default     = "v-rails6-9"
}

# インフラリソースに付与する Owner タグ
variable "owner_tag" {
  description = "Ownerタグの値"
  type        = string
  default     = "d2cx-test"
}
variable "environment" {
  description = "環境 (dev, prod のみ許可)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "環境変数 'environment' には 'dev', 'prod' のいずれかを指定してください。"
  }
}

variable "availability_zones"{
  description = "AZの指定"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

# 開発者拠点のIP制限設定
variable "developer_ip_whitelist" {
  description = "開発者拠点のIPアドレス制限リスト"
  type = list(object({
    cidr_block  = string
    description = string
  }))
  default = [
    {
      cidr_block  = "175.130.50.153/32"
      description = "wizgeek-office-m"
    }
  ]
}

# S3バケットIP制限の有効/無効設定
variable "enable_s3_ip_restriction" {
  description = "S3バケットのIP制限を有効にするかどうか"
  type        = bool
  default     = true
}

# ドメイン名 (CloudFront用ACM証明書)
variable "domain_name" {
  description = "CloudFront用のACM証明書を作成するドメイン名"
  type        = string
  default     = "tng-dev.sukejima.com"
}

# データベース認証情報
variable "db_username" {
  description = "Database username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "password"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "mydatabasev2"
}

# Rails設定
variable "rails_secret_key_base" {
  description = "Rails secret key base"
  type        = string
  sensitive   = true
  default     = "dummy_secret_key_for_development_do_not_use_in_production_12345678901234567890123456789012345678901234567890123456789012345678901234567890"
}

# メール設定
variable "noreply_email" {
  description = "No-reply email address"
  type        = string
  default     = "noreply@yourapp.com"
}

# CloudFront設定
variable "legacy_cloudfront_domain" {
  description = "Legacy CloudFront domain for fallback (will be removed in future)"
  type        = string
  default     = "d20aeo683mqd6t.cloudfront.net"
}
variable "use_custom_domain" {
  type    = bool
  default = false  # 初回作成時はDNS検証を省略したいので false にして apply
}