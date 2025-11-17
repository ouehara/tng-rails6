# Variables for temporary DB restore resources
# これらの変数は ../variables.tf から抽出されたものです

variable "aws_region" {
  description = "AWSのリージョン"
  type        = string
  default     = "us-west-2"
}

variable "app_identifier" {
  description = "アプリケーションの識別子"
  type        = string
  default     = "x-rails-0928"
}

variable "owner_tag" {
  description = "Ownerタグの値"
  type        = string
  default     = "shogo"
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

variable "availability_zones" {
  description = "AZの指定"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
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

# 追加の変数（警告解消用）
variable "legacy_cloudfront_domain" {
  description = "Legacy CloudFront domain (not used in temp resources)"
  type        = string
  default     = ""
}

variable "rails_secret_key_base" {
  description = "Rails secret key base (not used in temp resources)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "noreply_email" {
  description = "No-reply email address (not used in temp resources)"
  type        = string
  default     = ""
}

variable "use_custom_domain" {
  description = "Use custom domain (not used in temp resources)"
  type        = bool
  default     = false
}

variable "developer_ip_whitelist" {
  description = "Developer IP whitelist (not used in temp resources)"
  type = list(object({
    cidr_block  = string
    description = string
  }))
  default = []
}

variable "enable_s3_ip_restriction" {
  description = "Enable S3 IP restriction (not used in temp resources)"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Domain name (not used in temp resources)"
  type        = string
  default     = ""
}