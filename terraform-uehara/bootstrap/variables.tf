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
  default     = "v-rails6"
}
# インフラリソースに付与する Owner タグ
variable "owner_tag" {
  description = "Ownerタグの値"
  type        = string
  default     = "d2cx-test"
}