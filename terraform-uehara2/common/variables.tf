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
# GitHub のユーザー or Organization の名前
variable "github_owner" {
  description = "GitHub のユーザー名 (個人の場合) または Organization 名 (組織の場合)"
  type        = string
  default     = "d2cx"
}

# GitHub のリポジトリ名
variable "github_repo" {
  description = "GitHub のリポジトリ名"
  type        = string
  default     = "tng"
}

#OIDCプロパイダー用のフィンガープリント
variable "oidc_finger_print" {
  description = "OIDCプロパイダー用のフィンガープリント"
  type        = string
  sensitive   = true
  default     = "6938fd4d98bab03faadb97b34396831e3780aea1"
}



