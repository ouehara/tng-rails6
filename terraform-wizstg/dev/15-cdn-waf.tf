#===============================================
# AWS WAF Configuration for CloudFront
# 
# CloudFrontディストリビューション用のWAF設定
# - 基本的な監視とログ収集のみ
# - デフォルトアクションはAllow（IP制限なし）
# - us-east-1リージョンで作成（CloudFront連携要件）
#===============================================

#-----------------------------------------------
# WAF Provider for us-east-1 region
# 
# CloudFrontとWAFを連携するためには、WAFをus-east-1で作成する必要がある
# 注意: us-east-1プロバイダーはmain.tfまたは別ファイルで定義する必要があります
#-----------------------------------------------


#-----------------------------------------------
# WAF Web ACL (Web Access Control List)
# 
# CloudFrontディストリビューション用のWeb ACL
# - すべてのIPからのアクセスを許可
# - Basic認証でアクセス制御を実施
# - WAFは監視とログ収集のみ
#-----------------------------------------------
resource "aws_wafv2_web_acl" "cloudfront_waf" {
  provider = aws.us_east_1
  
  name  = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-cloudfront-waf"
  description = "WAF for CloudFront distribution - Basic monitoring only"
  scope = "CLOUDFRONT"  # CloudFront用のスコープ指定

  # デフォルトアクション: Allow（IP制限を除外）
  default_action {
    allow {}
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