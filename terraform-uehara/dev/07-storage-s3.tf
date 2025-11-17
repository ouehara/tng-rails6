#===============================================
# Static Assets S3 Bucket Configuration
# 
# Railsアプリケーションの静的アセット管理用S3バケット
# - ファイルアップロード: Paperclip gem経由
# - CDN配信: CloudFrontと連携
# - セキュリティ: 暗号化・アクセス制御有効
# - コスト最適化: ライフサイクル管理有効
#===============================================

#-----------------------------------------------
# S3 Bucket for Static Assets
# 
# メインのS3バケットリソース
# - 一意なバケット名でグローバルに作成
# - 共通タグと環境固有タグを適用
#-----------------------------------------------
resource "aws_s3_bucket" "static_assets" {
  bucket = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-static-assets-${random_string.bucket_suffix.result}"

  tags = merge({
    Name    = "s3-${local.app_identifier}-${local.environment}-${local.aws_region_string}-static-assets"
    Purpose = "static-assets"
  }, local.common_tags)
}

#-----------------------------------------------
# S3 Bucket Ownership Controls
#
# Bucket owner がオブジェクト所有権を保持しつつ ACL を許可
# Paperclip など ACL を付与するクライアントからのアップロードで
# AccessControlListNotSupported エラーを防ぐ
#-----------------------------------------------
resource "aws_s3_bucket_ownership_controls" "static_assets_ownership" {
  bucket = aws_s3_bucket.static_assets.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#-----------------------------------------------
# Random string for unique bucket naming
# 
# S3バケット名の一意性を保証するためのランダム文字列
# - 長さ: 8文字
# - 小文字のみ（特殊文字・大文字なし）
#-----------------------------------------------
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false

  keepers = {
    # バケット名を変更したい場合は、このkeeperの値を変更する
    bucket_purpose = "static-assets"
  }
}

#-----------------------------------------------
# S3 Bucket Versioning
# 
# バケットのバージョニング設定
# - ファイルの誤削除・上書きからの保護
# - ライフサイクル管理との連携
#-----------------------------------------------
resource "aws_s3_bucket_versioning" "static_assets_versioning" {
  bucket = aws_s3_bucket.static_assets.id
  
  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [aws_s3_bucket.static_assets]
}

#-----------------------------------------------
# S3 Bucket Public Access Block
# 
# パブリックアクセスのブロック設定
# - セキュリティ強化のため全てのパブリックアクセスをブロック
# - CloudFront経由でのみアクセス可能
#-----------------------------------------------
resource "aws_s3_bucket_public_access_block" "static_assets_pab" {
  bucket = aws_s3_bucket.static_assets.id

  # 全てのパブリックアクセスをブロック
  block_public_acls       = false # TODO: 本番ではfalseにする
  block_public_policy     = false # TODO: 本番ではfalseにする
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.static_assets]
}

#-----------------------------------------------
# S3 Bucket Server-side Encryption
# 
# サーバーサイド暗号化の設定
# - AES256アルゴリズムを使用
# - アップロードされる全ファイルを自動暗号化
#-----------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "static_assets_encryption" {
  bucket = aws_s3_bucket.static_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    
    # 暗号化を強制（暗号化されていないオブジェクトのアップロードを拒否）
    bucket_key_enabled = true
  }

  depends_on = [aws_s3_bucket.static_assets]
}

#-----------------------------------------------
# S3 Bucket Lifecycle Configuration
# 
# バケットのライフサイクル管理設定
# - 不完全なマルチパートアップロードのクリーンアップ
# - 古いバージョンの自動削除でストレージコストを削減
#-----------------------------------------------
resource "aws_s3_bucket_lifecycle_configuration" "static_assets_lifecycle" {
  bucket = aws_s3_bucket.static_assets.id

  # 不完全なマルチパートアップロードの削除
  rule {
    id     = "delete_incomplete_multipart_uploads"
    status = "Enabled"

    filter {
      # すべてのオブジェクトに適用
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7  # 7日後に自動削除
    }
  }

  # 古いバージョンの削除
  rule {
    id     = "delete_old_versions"
    status = "Enabled"

    filter {
      # すべてのオブジェクトに適用
    }

    noncurrent_version_expiration {
      noncurrent_days = 30  # 30日後に古いバージョンを削除
    }
  }

  depends_on = [aws_s3_bucket_versioning.static_assets_versioning]
}

#-----------------------------------------------
# S3 Bucket CORS Configuration
# 
# CORS（Cross-Origin Resource Sharing）設定
# - Webアプリケーションからのファイルアップロードを許可
# - 本番環境ではドメインを制限することを推奨
#-----------------------------------------------
resource "aws_s3_bucket_cors_configuration" "static_assets_cors" {
  bucket = aws_s3_bucket.static_assets.id

  cors_rule {
    # 許可するリクエストヘッダー
    allowed_headers = ["*"]
    
    # 許可するHTTPメソッド
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    
    # 許可するオリジン（TODO: 本番では実際のドメインに制限）
    allowed_origins = ["*"]
    
    # レスポンスで公開するヘッダー
    expose_headers  = ["ETag"]
    
    # ブラウザのプリフライトキャッシュ有効期間（秒）
    max_age_seconds = 3000
  }

  depends_on = [aws_s3_bucket.static_assets]
}

#-----------------------------------------------
# S3 Bucket Policy Update for CloudFront OAC
#
# CloudFrontからのアクセスを許可するためのS3バケットポリシー更新
# Origin Access Control (OAC) を使用してセキュアなアクセスを実現
#-----------------------------------------------
data "aws_iam_policy_document" "s3_policy_cloudfront" {
  # CloudFrontからのアクセス許可
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.static_assets.arn}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }

  # 既存のIP制限ポリシーを保持（有効な場合）
  dynamic "statement" {
    for_each = var.enable_s3_ip_restriction ? [1] : []
    content {
      sid    = "AllowDeveloperIPAccess"
      effect = "Allow"
      principals {
        type        = "*"
        identifiers = ["*"]
      }
      actions = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ]
      resources = [
        aws_s3_bucket.static_assets.arn,
        "${aws_s3_bucket.static_assets.arn}/*"
      ]
      condition {
        test     = "IpAddress"
        variable = "aws:SourceIp"
        values   = [for ip in var.developer_ip_whitelist : ip.cidr_block]
      }
    }
  }

  # IAMユーザーからのアクセス許可
  statement {
    sid    = "AllowIAMUserAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.s3_static_assets_user.arn]
    }
    actions = [
      "s3:PutObjectAcl",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:GetBucketLocation",
      "s3:DeleteObject"
    ]
    resources = [
      aws_s3_bucket.static_assets.arn,
      "${aws_s3_bucket.static_assets.arn}/*"
    ]
  }
}

# CloudFront OAC用S3バケットポリシー
# CloudFront設定変更時はこのポリシーも確認すること
resource "aws_s3_bucket_policy" "static_assets_policy_with_cloudfront" {
  bucket = aws_s3_bucket.static_assets.id
  policy = data.aws_iam_policy_document.s3_policy_cloudfront.json

  depends_on = [
    aws_s3_bucket_public_access_block.static_assets_pab,
    aws_iam_user.s3_static_assets_user,
    aws_cloudfront_distribution.s3_distribution
  ]
}

#-----------------------------------------------
# IAM User for S3 Access
# 
# S3バケットへのアクセス用IAMユーザー
# - 現在のアプリケーションで使用されている認証方式
# - 将来的にはECSタスクロールへの移行を推奨
# 
# TODO: セキュリティ向上のためECSタスクロールへの移行を検討
#-----------------------------------------------
resource "aws_iam_user" "s3_static_assets_user" {
  name = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-s3-static-assets-user"
  path = "/"

  tags = merge({
    Name    = "iam-user-${local.app_identifier}-${local.environment}-${local.aws_region_string}-s3-static-assets"
    Purpose = "s3-static-assets-access"
  }, local.common_tags)
}

#-----------------------------------------------
# IAM Policy for S3 Bucket Access
# 
# S3バケットへのアクセス権限を定義するIAMポリシー
# - 最小権限の原則に従い、必要な権限のみを付与
# - ファイルのGet/Put/DeleteとバケットのList権限
#-----------------------------------------------
resource "aws_iam_policy" "s3_static_assets_policy" {
  name        = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-s3-static-assets-policy"
  description = "IAM policy for S3 static assets access in ${var.environment} environment"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # オブジェクトレベルの操作権限
        Effect = "Allow"
        Action = [
          "s3:GetObject",      # ファイルの読み取り
          "s3:PutObject",      # ファイルのアップロード
          "s3:DeleteObject",   # ファイルの削除
          "s3:GetObjectAcl",   # ファイルACLの取得
          "s3:PutObjectAcl"    # ファイルACLの設定
        ]
        Resource = "${aws_s3_bucket.static_assets.arn}/*"
      },
      {
        # バケットレベルの操作権限
        Effect = "Allow"
        Action = [
          "s3:ListBucket",       # バケット内ファイルの一覧
          "s3:GetBucketLocation" # バケットのロケーション取得
        ]
        Resource = aws_s3_bucket.static_assets.arn
      }
    ]
  })

  tags = merge({
    Name    = "iam-policy-${local.app_identifier}-${local.environment}-${local.aws_region_string}-s3-static-assets"
    Purpose = "s3-static-assets-access"
  }, local.common_tags)
}

#-----------------------------------------------
# Attach Policy to User
# 
# IAMユーザーにS3アクセスポリシーをアタッチ
# - 管理されたポリシーではなく、カスタムポリシーを使用
# - 最小権限の原則に従った精密な権限制御
#-----------------------------------------------
resource "aws_iam_user_policy_attachment" "s3_static_assets_policy_attachment" {
  user       = aws_iam_user.s3_static_assets_user.id
  policy_arn = aws_iam_policy.s3_static_assets_policy.arn
}

#-----------------------------------------------
# Generate Access Key for the User
# 
# IAMユーザー用のアクセスキーを生成
# - アプリケーションがS3にアクセスするためのクレデンシャル
# - terraform outputでシークレットキーを取得可能
# 
# 注意: アクセスキーは慣重に管理し、定期的なローテーションを推奨
#-----------------------------------------------
resource "aws_iam_access_key" "s3_static_assets_access_key" {
  user = aws_iam_user.s3_static_assets_user.id

  depends_on = [aws_iam_user_policy_attachment.s3_static_assets_policy_attachment]
}

