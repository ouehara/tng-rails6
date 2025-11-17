#===============================================
# AWS WAF Configuration for CloudFront
# 
# CloudFrontディストリビューション用のWAF設定
# - 開発者IPホワイトリストによるアクセス制御
# - デフォルトアクションはBlock（セキュリティ強化）
# - us-east-1リージョンで作成（CloudFront連携要件）
#===============================================

#-----------------------------------------------
# WAF Provider for us-east-1 region
# 
# CloudFrontとWAFを連携するためには、WAFをus-east-1で作成する必要がある
# 注意: us-east-1プロバイダーはmain.tfまたは別ファイルで定義する必要があります
#-----------------------------------------------

#-----------------------------------------------
# WAF IP Set (Developer IP Whitelist)
# 
# developer_ip_whitelist変数からIPセットを生成
# 開発者拠点のIPアドレスのみアクセスを許可
#-----------------------------------------------
resource "aws_wafv2_ip_set" "developer_ip_whitelist" {
  provider = aws.us_east_1
  
  name               = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-developer-ip-whitelist"
  description        = "Developer IP whitelist for ${local.app_identifier} ${local.environment} environment"
  scope              = "CLOUDFRONT"  # CloudFront用のスコープ指定
  ip_address_version = "IPV4"

  # developer_ip_whitelist変数からCIDRブロックのリストを抽出
  addresses = [for ip in var.developer_ip_whitelist : ip.cidr_block]

  tags = merge({
    Name    = "waf-ipset-${local.app_identifier}-${local.environment}-${local.aws_region_string}-developers"
    Purpose = "developer-ip-whitelist"
  }, local.common_tags)
}

#-----------------------------------------------
# WAF Web ACL (Web Access Control List)
# 
# CloudFrontディストリビューション用のWeb ACL
# - 開発者IPからのアクセスのみ許可
# - その他のIPからのアクセスはブロック
# - デフォルトアクションはBlock（セキュリティ強化）
#-----------------------------------------------
resource "aws_wafv2_web_acl" "cloudfront_waf" {
  provider = aws.us_east_1
  
  name  = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-cloudfront-waf"
  description = "WAF for CloudFront distribution - Developer IP restriction"
  scope = "CLOUDFRONT"  # CloudFront用のスコープ指定

  # デフォルトアクション: Block（要件通り）
  default_action {
    block {}
  }

  # ルール1: 開発者IPホワイトリストからのアクセスを許可
  rule {
    name     = "AllowDeveloperIPs"
    priority = 1

    # IPSetマッチ条件
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.developer_ip_whitelist.arn
      }
    }

    # マッチした場合のアクション: Allow
    action {
      allow {}
    }

    # 可視性設定
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.app_identifier}-${local.environment}-AllowDeveloperIPs"
    }
  }

  # CloudWatch メトリクス設定
  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.app_identifier}-${local.environment}-CloudFrontWAF"
  }

  tags = merge({
    Name    = "waf-webacl-${local.app_identifier}-${local.environment}-${local.aws_region_string}-cloudfront"
    Purpose = "cloudfront-access-control"
  }, local.common_tags)
}