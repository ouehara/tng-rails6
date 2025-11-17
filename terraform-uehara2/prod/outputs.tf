output "alb_domain_url" {
  description = "Domain URL for accessing the application"
  value       = "https://${var.domain_name}"
}

output "alb_security_group_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.alb_sg.id
}

output "cloudfront_acm_dns_validations" {
  description = "CloudFront証明書のDNS検証用CNAMEレコード（Cloudflareに設定してください）"
  value = [
    for dvo in aws_acm_certificate.cloudfront_cert.domain_validation_options : {
      domain_name = dvo.domain_name
      name        = dvo.resource_record_name
      type        = dvo.resource_record_type
      value       = dvo.resource_record_value
    }
  ]
}

output "alb_acm_dns_validations" {
  description = "ALB証明書のDNS検証用CNAMEレコード（ALB内部用ドメイン、Cloudflareに設定してください）"
  value = [
    for dvo in aws_acm_certificate.alb_cert.domain_validation_options : {
      domain_name = dvo.domain_name
      name        = dvo.resource_record_name
      type        = dvo.resource_record_type
      value       = dvo.resource_record_value
    }
  ]
}

output "cloudfront_domain_name" {
  description = "CloudFrontディストリビューションのドメイン名（CloudflareのCNAMEレコードに設定してください）"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

# Debug環境用の出力
output "vpc_endpoint_sg_id" {
  description = "VPCエンドポイント用セキュリティグループID"
  value       = aws_security_group.vpc_endpoint_sg.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  description = "プライベートサブネットID一覧"
  value       = aws_subnet.private_subnet[*].id
}

output "rds_endpoint" {
  description = "RDSインスタンスのエンドポイント"
  value       = aws_db_instance.rds_instance.address
}

output "rds_database_name" {
  description = "RDSデータベース名"
  value       = aws_db_instance.rds_instance.db_name
}

output "rds_security_group_id" {
  description = "RDSセキュリティグループID"
  value       = aws_security_group.rds_sg.id
}

# ALB関連の出力（debug環境用）
output "alb_target_group_arn" {
  description = "ALBターゲットグループARN"
  value       = aws_lb_target_group.alb_tg.arn
}

output "alb_listener_arn" {
  description = "ALBリスナーARN"
  value       = aws_lb_listener.alb_listener_https.arn
}

output "alb_dns_name" {
  description = "ALBのDNS名"
  value       = aws_lb.alb.dns_name
}