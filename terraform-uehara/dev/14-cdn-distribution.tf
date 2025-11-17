#===============================================
# CloudFront Distribution Configuration
#
# CDN配信ポリシー・キャッシュ戦略
# 運用担当：CDN配信ポリシー・パフォーマンス管理チーム
#===============================================

#-----------------------------------------------
# CloudFront Distribution（CDN移行戦略: オリジンフォールバック方式）
#
# 【CDN移行戦略: オリジンフォールバック方式】
# データ移行を行わずに旧CDNから新CDNに段階的移行する手法
#
# 仕組み:
# 1. ユーザーが新CDN（新CloudFront）にアクセス
# 2. 新CDNにファイルがない場合 → 旧CDNから取得
# 3. 新CDNにキャッシュされる
# 4. 次回以降は新CDNから直接配信
#
# メリット:
# - データ移行不要: 既存ファイルはそのまま旧CDNに残す
# - 段階的移行: アクセスされたファイルから順次新CDNに蓄積
# - ダウンタイムなし: シームレスな切り替えが可能
# - コスト効率: 実際に使用されるファイルのみ新CDNに移行
# - 自動最適化: 人気ファイルほど早く新CDNにキャッシュされる
#
# 注意点:
# - 初回アクセス時のみ若干のレイテンシ増加（旧CDN経由のため）
# - 旧CDNは段階的に縮小可能（アクセスログ確認後に不要ファイル削除）
#-----------------------------------------------
resource "aws_cloudfront_distribution" "s3_distribution" {
  # WAF Web ACLの関連付け（開発者IP制限）
  web_acl_id = aws_wafv2_web_acl.cloudfront_waf.arn

  # Primary Origin: 新しいS3バケット（新規アップロード用）
  # 新しくアップロードされるファイルはこちらから配信
  origin {
    domain_name              = aws_s3_bucket.static_assets.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
    origin_id                = "S3-Primary"
  }

  # VPC Origin: プライベートALB（Railsアプリケーション用）
  # 既存のVPC Origin ID: vo_JpE2IyuOmwSF7YDBFfS3oB を使用
  origin {
    domain_name = "alb-${var.domain_name}"  # 証明書と一致するドメイン名を使用
    origin_id   = "VPC-ALB-Rails"

    vpc_origin_config {
      vpc_origin_id             = aws_cloudfront_vpc_origin.alb_vpc_origin.id
      origin_keepalive_timeout  = 5
      origin_read_timeout       = 30
    }
  }

  # Fallback Origin: 旧CloudFront（既存ファイル用）
  # 新CDNにファイルがない場合、旧CDNから取得してキャッシュ
  origin {
    domain_name = var.legacy_cloudfront_domain
    origin_id   = "OldCDN-Fallback"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ${local.app_identifier} ${local.environment} static assets"
  # default_root_object = "index.html"  # Railsアプリケーションのためコメントアウト

  # 最小限のエッジロケーション（コスト最適化）
  price_class = "PriceClass_100"

  # デフォルトキャッシュビヘイビア
  # HTMLページとAPIレスポンスはRailsアプリケーション（ALB）から配信
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "VPC-ALB-Rails"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0       # HTMLページはキャッシュしない
    max_ttl                = 0       # HTMLページはキャッシュしない
    compress               = true
  }

  # Admin画面用キャッシュビヘイビア（キャッシュ無効化）
  # admin1500011配下のすべてのページでキャッシュを無効化
  ordered_cache_behavior {
    path_pattern     = "/admin1500011/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "VPC-ALB-Rails"

    forwarded_values {
      query_string = true  # admin画面ではクエリパラメータを転送
      headers      = ["*"]  # すべてのヘッダーを転送（認証情報含む）

      cookies {
        forward = "all"  # すべてのCookieを転送（セッション情報含む）
      }
    }

    min_ttl                = 0
    default_ttl            = 0        # キャッシュ無効化
    max_ttl                = 0        # キャッシュ無効化
    compress               = false    # 動的コンテンツのため圧縮無効
    viewer_protocol_policy = "redirect-to-https"
  }

  # Devise認証用キャッシュビヘイビア（キャッシュ無効化）
  # ユーザー認証・登録・パスワード関連でキャッシュを無効化
  ordered_cache_behavior {
    path_pattern     = "/users/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "VPC-ALB-Rails"

    forwarded_values {
      query_string = true  # 認証パラメータを転送
      headers      = ["*"]  # すべてのヘッダーを転送（認証情報含む）

      cookies {
        forward = "all"  # すべてのCookieを転送（セッション情報含む）
      }
    }

    min_ttl                = 0
    default_ttl            = 0        # キャッシュ無効化
    max_ttl                = 0        # キャッシュ無効化
    compress               = false    # 動的コンテンツのため圧縮無効
    viewer_protocol_policy = "redirect-to-https"
  }

  # 静的アセット用キャッシュビヘイビア（長期キャッシュ）
  # 新規アップロードされたアセットファイル用
  ordered_cache_behavior {
    path_pattern     = "/assets/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-Primary"

    forwarded_values {
      query_string = false
      headers      = ["Origin", "User-Agent", "Accept", "Accept-Encoding"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 31536000  # 1年
    max_ttl                = 31536000  # 1年
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # 既存記事画像用キャッシュビヘイビア（旧CDNフォールバック）
  # 記事のタイトル画像など、既存コンテンツは旧CDNから取得
  ordered_cache_behavior {
    path_pattern     = "/articles/title_images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "OldCDN-Fallback"

    forwarded_values {
      query_string = true  # クエリパラメータ（サイズ指定等）を保持
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400     # 1日
    max_ttl                = 31536000  # 1年
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # その他画像ファイル用キャッシュビヘイビア（旧CDNフォールバック）
  # /images/imgs/* パスの既存画像ファイル用
  ordered_cache_behavior {
    path_pattern     = "/images/imgs/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "OldCDN-Fallback"

    forwarded_values {
      query_string = true  # クエリパラメータを保持
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400     # 1日
    max_ttl                = 31536000  # 1年
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # webpack/パックファイル用キャッシュビヘイビア（新S3バケット）
  # webpackでコンパイルされたファイル（CSS、JS、画像等）を新S3から配信
  ordered_cache_behavior {
    path_pattern     = "/packs/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-Primary"

    forwarded_values {
      query_string = false
      headers      = ["Origin", "User-Agent", "Accept", "Accept-Encoding"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 31536000  # 1年（ハッシュ付きファイルのため長期キャッシュ）
    max_ttl                = 31536000  # 1年
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # フィード用キャッシュビヘイビア（旧CDNフォールバック）
  # RSSフィードなど
  ordered_cache_behavior {
    path_pattern     = "/feed/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "OldCDN-Fallback"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600      # 1時間（フィードは更新頻度が高い）
    max_ttl                = 86400     # 1日
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # 汎用画像ファイル用キャッシュビヘイビア（新規S3優先）
  # *.jpg ファイル用（新規アップロード画像）
  ordered_cache_behavior {
    path_pattern     = "*.jpg"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-Primary"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400     # 1日
    max_ttl                = 31536000  # 1年
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # *.png ファイル用（新規アップロード画像）
  ordered_cache_behavior {
    path_pattern     = "*.png"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-Primary"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400     # 1日
    max_ttl                = 31536000  # 1年
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # TODO 地理的制限（開発環境用：日本のみアクセス許可）
  # 🚨 TODO 本番環境では必ずこの制限を外すこと（restriction_type = "none"に変更）
  restrictions {
    geo_restriction {
      restriction_type = "none"  # 開発用制限：本番時にnoneに変更必須
      locations        = []       # 日本のみ許可
    }
  }

  # カスタムドメイン設定
  aliases = local.use_custom_ssl ? [var.domain_name] : []

  # SSL証明書設定（CloudFrontでSSL終端）
  viewer_certificate {
    cloudfront_default_certificate = !local.use_custom_ssl
    acm_certificate_arn            = local.use_custom_ssl ? aws_acm_certificate.cloudfront_cert.arn : null
    ssl_support_method             = local.use_custom_ssl ? "sni-only" : null
    minimum_protocol_version       = local.use_custom_ssl ? "TLSv1.2_2021" : null
  }

  # CloudFrontログ設定（デバッグ用）
  # logging_config {
  #   bucket          = "${aws_s3_bucket.static_assets.bucket_domain_name}"
  #   include_cookies = true
  #   prefix          = "cloudfront-logs/"
  # }

  tags = merge({
    Name    = "cloudfront-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
    Purpose = "static-assets-cdn"
  }, local.common_tags)

  depends_on = [
    aws_s3_bucket.static_assets,
    aws_wafv2_web_acl.cloudfront_waf,
    aws_acm_certificate.cloudfront_cert
  ]
}