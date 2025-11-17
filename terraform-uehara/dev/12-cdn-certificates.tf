#===============================================
# CloudFront SSL Certificates
#
# SSL/TLS証明書管理
# 運用担当：セキュリティ・証明書管理チーム
#===============================================

# Local variables for cleaner logic
locals {
  use_custom_ssl = var.use_custom_domain
}

#-----------------------------------------------
# ACM Certificate for CloudFront (us-east-1 required)
#
# CloudFrontでカスタムドメインを使用するためにus-east-1リージョンに証明書を作成
# CloudFrontの要件により、必ずus-east-1リージョンである必要がある
#-----------------------------------------------
resource "aws_acm_certificate" "cloudfront_cert" {
  provider                  = aws.us_east_1
  domain_name               = var.domain_name
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    Name    = "cloudfront-cert-${local.app_identifier}-${local.environment}"
    Purpose = "cloudfront-ssl-termination"
  }, local.common_tags)
}

#-----------------------------------------------
# Certificate Validation
#
# DNS検証による証明書の有効化
# 運用注意：初回作成時はDNS設定完了後に有効化
#-----------------------------------------------
resource "aws_acm_certificate_validation" "cloudfront_cert_validation" {
  provider        = aws.us_east_1
  count           = local.use_custom_ssl ? 1 : 0
  certificate_arn = aws_acm_certificate.cloudfront_cert.arn

  timeouts {
    create = "5m"
  }
}

#-----------------------------------------------
# ACM Certificate for ALB (ap-northeast-1)
#
# ALBでHTTPS終端するための証明書を東京リージョンに作成
# CloudFront→ALB間のTLS通信で使用
#-----------------------------------------------
resource "aws_acm_certificate" "alb_cert" {
  # providerの指定なし = デフォルトのap-northeast-1を使用
  domain_name               = "alb-${var.domain_name}"
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    Name    = "alb-cert-${local.app_identifier}-${local.environment}"
    Purpose = "alb-ssl-termination"
    Region  = "ap-northeast-1"
  }, local.common_tags)
}

#-----------------------------------------------
# ALB Certificate Validation
#
# DNS検証によるALB証明書の有効化
#-----------------------------------------------
resource "aws_acm_certificate_validation" "alb_cert_validation" {
  count           = local.use_custom_ssl ? 1 : 0
  certificate_arn = aws_acm_certificate.alb_cert.arn

  # validation_record_fqdns = [for record in aws_acm_certificate.alb_cert.domain_validation_options : record.resource_record_value]
  validation_record_fqdns = [
      for record in aws_acm_certificate.alb_cert.domain_validation_options : record.resource_record_name
  ]

  timeouts {
    create = "5m"
  }
}