#===============================================
# CloudFront Origins Configuration
#
# CDNオリジン設定
# 運用担当：インフラ・CDN設定チーム
#===============================================

#-----------------------------------------------
# CloudFront VPC Origin
#
# ALBをプライベートサブネットに配置し、CloudFront経由のみアクセス許可
# パブリックインターネットから直接アクセス不可
# 注意：既存のVPC Origin ID "vo_JpE2IyuOmwSF7YDBFfS3oB" を使用
#-----------------------------------------------
resource "aws_cloudfront_vpc_origin" "alb_vpc_origin" {
  vpc_origin_endpoint_config {
    name                   = "${local.app_identifier}-${local.environment}-alb-vpc-origin"
    arn                    = aws_lb.alb.arn
    http_port              = 80
    https_port             = 443
    origin_protocol_policy = "https-only"  # internal ALBへHTTPS通信
    origin_ssl_protocols {
      items    = ["TLSv1.2"]
      quantity = 1
    }
  }

  tags = merge({
    Name    = "vpc-origin-${local.app_identifier}-${local.environment}"
    Purpose = "alb-private-access"
  }, local.common_tags)

  timeouts {
    create = "30m"
  }

  # CloudFront Distribution との依存関係を管理
  lifecycle {
    create_before_destroy = true
  }
}

#-----------------------------------------------
# CloudFront Origin Access Control (OAC)
#
# S3バケットへの直接アクセスを制限し、CloudFront経由のみに制限
# Origin Access Identity (OAI) の後継として推奨される新方式
#-----------------------------------------------
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-s3-oac"
  description                       = "OAC for S3 static assets bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}