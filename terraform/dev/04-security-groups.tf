#===============================================
# Application Security Groups
#
# Security groups for application layer components
# Dependencies:
# - VPC (network.tf)
# Note: Infrastructure security groups (vpc_endpoint_sg) remain in network.tf
#===============================================

#---------------------------------------
# ALB Security Group
#---------------------------------------

# ALB 用のセキュリティグループ
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
  description = "ALB SG - CloudFront and private subnet access only"
  vpc_id      = aws_vpc.vpc.id

  # CloudFrontからのHTTPSアクセス許可（VPC Origin）
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-58a04531"]  # CloudFront managed prefix list
    description     = "CloudFront VPC Origin HTTPS access"
  }

  # CloudFront IP ranges からのHTTPアクセス許可（VPCオリジン用）
  # Note: CloudFront VPC Origin は AWS 内部 IP から接続されるため、
  # より制限的なアプローチが必要な場合は、VPC Origin の特定 IP range を使用
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # CloudFront VPC Origin 用（AWS内部接続）
    description = "CloudFront VPC Origin HTTP access"
  }

  # egress全許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

#---------------------------------------
# ECS Security Group
#---------------------------------------

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
  description = "ECS SG"
  vpc_id      = aws_vpc.vpc.id

  # ALB からの通信を許可 (ターゲットグループ)
  ingress {
    from_port       = 3000 # TODO
    to_port         = 3000 # TODO
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # ALB の SG を許可
  }

  # すべてのアウトバウンド通信を許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

#---------------------------------------
# Security Group Rules
#---------------------------------------

# `ecs_sg` から `vpc_endpoint_sg` への HTTPS (443) アクセスを許可
resource "aws_security_group_rule" "ecs_to_vpc_endpoint" {
  security_group_id        = aws_security_group.vpc_endpoint_sg.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_sg.id
}

#---------------------------------------
# RDS Security Group Rules
#---------------------------------------

# ECS から RDS への PostgreSQL アクセスを許可
resource "aws_security_group_rule" "ecs_to_rds" {
  security_group_id        = aws_security_group.rds_sg.id
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_sg.id
  description              = "Allow ECS access to RDS"
}