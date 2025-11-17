#===============================================
# 一時的なDB復旧用インフラストラクチャ (temp/)
#===============================================
#
# 注意: このファイルは temp/ ディレクトリに移動されました
#
# 移動理由:
# - 一時的な用途のリソース（作業完了後削除予定）
# - 本番インフラコードとの分離
# - 開発時のDB操作・デバッグ用途のみ
#
# 使用方法:
# cd temp/
# terraform init
# terraform apply -var-file=../terraform_dev.tfvars
#
#===============================================
# 【重要】このファイルは開発環境用の暫定的なデバッグ環境設定です
#
# 目的:
# - データベース復旧操作専用のEC2インスタンスと関連リソース
# - S3からのバックアップファイル取得とPostgreSQLへの復元
# - 本番運用ではなく、開発時のDB操作・デバッグ用途のみ
#
# 構成要素:
# 1. EC2インスタンス (プライベートサブネット)
# 2. 一時的なS3バケット (us-west-2、復旧完了後削除)
# 3. STS VPCエンドポイント (AWS CLI認証用)
# 4. IAMロールと権限設定
#
# 特徴:
# - デフォルトで停止状態（コスト最適化）
# - 毎日19時JST（10時UTC）に自動停止
# - 手動起動が必要（使用時のみ課金）
#
# セキュリティ:
# - SSM Session Managerのみでアクセス
# - プライベートサブネット配置
# - RDSへの接続権限あり
# - S3バックアップファイルへの読み取り専用アクセス
#
# 削除手順 (復旧作業完了後):
# 1. terraform destroy -target=aws_s3_bucket.temp_db_restore_bucket
# 2. terraform destroy -target=aws_vpc_endpoint.sts
# 3. terraform destroy -target=aws_instance.db_restore_ec2
# 4. このファイル自体を削除
#
#===============================================

## こいつは別途削除する

#---------------------------------------
# EC2 Instance for Database Operations
#---------------------------------------

# IAM Role for EC2 to access S3
resource "aws_iam_role" "ec2_db_restore_role" {
  name = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-ec2-db-restore-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

# IAM Policy for S3 access
resource "aws_iam_role_policy" "ec2_s3_access" {
  name = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-ec2-s3-policy"
  role = aws_iam_role.ec2_db_restore_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.temp_db_restore_bucket.arn,
          "${aws_s3_bucket.temp_db_restore_bucket.arn}/*"
        ]
      }
    ]
  })
}

# IAM Policy for temp S3 bucket access
resource "aws_iam_role_policy" "ec2_temp_s3_access" {
  name = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-ec2-temp-s3-policy"
  role = aws_iam_role.ec2_db_restore_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.temp_db_restore_bucket.arn,
          "${aws_s3_bucket.temp_db_restore_bucket.arn}/*"
        ]
      }
    ]
  })
}

# IAM Policy attachment for SSM
resource "aws_iam_role_policy_attachment" "ec2_ssm_managed_instance_core" {
  role       = aws_iam_role.ec2_db_restore_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile
resource "aws_iam_instance_profile" "ec2_db_restore_profile" {
  name = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-ec2-db-restore-profile"
  role = aws_iam_role.ec2_db_restore_role.id

  tags = local.common_tags
}

# Security Group for EC2 DB Restore Instance
resource "aws_security_group" "ec2_db_restore_sg" {
  name        = "ec2-db-restore-sg-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
  description = "Security group for DB restore EC2 instance"
  vpc_id      = data.terraform_remote_state.dev.outputs.vpc_id

  # Allow all outbound traffic (needed for SSM, PostgreSQL, S3, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge({
    Name = "ec2-db-restore-sg-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
  }, local.common_tags)
}

#-----------------------------------------------
# VPC Endpoint Security Group Rule for SSM Access
# debug環境のEC2からVPCエンドポイントへのHTTPSアクセスを許可
#-----------------------------------------------
resource "aws_security_group_rule" "debug_ec2_to_vpc_endpoint" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2_db_restore_sg.id
  security_group_id        = data.terraform_remote_state.dev.outputs.vpc_endpoint_sg_id
  description              = "Allow debug EC2 access to VPC endpoints for SSM"
}

#-----------------------------------------------
# ALB Security Group Rule for Debug EC2 Access
# debug環境のEC2からALBへのHTTPSアクセスを許可（デバッグ・監視用）
#-----------------------------------------------
resource "aws_security_group_rule" "debug_ec2_to_alb_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2_db_restore_sg.id
  security_group_id        = data.terraform_remote_state.dev.outputs.alb_security_group_id
  description              = "Allow debug EC2 HTTPS access to ALB for debugging and monitoring"
}

#-----------------------------------------------
# RDS Security Group Rule for Debug EC2 Access
# debug環境のEC2からRDSへの5432ポートアクセスを許可
#-----------------------------------------------
resource "aws_security_group_rule" "debug_ec2_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2_db_restore_sg.id
  security_group_id        = data.terraform_remote_state.dev.outputs.rds_security_group_id
  description              = "Allow debug EC2 access to RDS"
}

# EC2 Instance for Database Restore
resource "aws_instance" "db_restore_ec2" {
  ami                         = "ami-0e424e4efe8c00b7d"  # Amazon Linux 2 (2025-09-15) in ap-northeast-1 - latest
  # ami                         = "ami-024e4b8b6ef78434a"  # Amazon Linux 2 in us-west-2 (Oregon) - DO NOT USE in Tokyo region
  # instance_type               = "t3.large"  # $0.0832/時間 - DB復旧に適したバランス型 (2 vCPU, 8GB RAM)
  instance_type               = "t3.medium"  # $0.0416/時間 - より低コスト (2 vCPU, 4GB RAM)
  # instance_type               = "c7i.2xlarge"  # $0.374/時間 - 大容量処理が必要な場合
  subnet_id                   = data.terraform_remote_state.dev.outputs.private_subnet_ids[0]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ec2_db_restore_profile.id
  vpc_security_group_ids      = [aws_security_group.ec2_db_restore_sg.id]

  # IMDSv2 を必須化（SSRF対策）
  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 80
    encrypted             = true
    delete_on_termination = true
    iops        = 6000
    throughput  = 250
  }

  # User data with successful PostgreSQL installation and restore scripts
  user_data = <<-EOF
              #!/bin/bash
              # ログ出力設定
              exec > /var/log/user-data.log 2>&1
              echo "User-data script started at $(date)"

              # PostgreSQL 14クライアントとAWS CLIのインストール
              echo "Installing PostgreSQL 14 and AWS CLI..."
              yum update -y
              amazon-linux-extras enable postgresql14
              yum install -y postgresql aws-cli unzip

              echo "Installed versions:"
              psql --version
              aws --version

              # SSM Agent の確認と設定
              echo "Ensuring SSM Agent is running..."
              systemctl enable amazon-ssm-agent
              systemctl restart amazon-ssm-agent
              systemctl status amazon-ssm-agent --no-pager || true

              # Create a simple README file with basic information
              cat > /home/ec2-user/README.md << 'SCRIPT'
# DB Restore EC2 Instance

このインスタンスはDB復旧専用です。

## 利用方法
詳細な手順は terraform による環境構築手順.md を参照してください。

## 設定情報
- RDS Endpoint: ${data.terraform_remote_state.dev.outputs.rds_endpoint}
- Database: ${data.terraform_remote_state.dev.outputs.rds_database_name}
- User: ${var.db_username}
- S3 Bucket: ${aws_s3_bucket.temp_db_restore_bucket.bucket}
- Region: ${local.aws_region}

SCRIPT

              chown ec2-user:ec2-user /home/ec2-user/README.md

              echo "User-data script completed successfully at $(date)"
              echo "Database restore scripts are available in /home/ec2-user/"
              echo "See /home/ec2-user/README.md for usage instructions"
              EOF

  tags = merge({
    Name = "db-restore-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
  }, local.common_tags)
}

#---------------------------------------
# STS VPC Endpoint for AWS CLI Authentication
#---------------------------------------

# STS VPCエンドポイント (AWS CLI認証用)
resource "aws_vpc_endpoint" "sts" {
  vpc_id              = data.terraform_remote_state.dev.outputs.vpc_id
  service_name        = "com.amazonaws.${local.aws_region}.sts"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.terraform_remote_state.dev.outputs.private_subnet_ids
  security_group_ids  = [data.terraform_remote_state.dev.outputs.vpc_endpoint_sg_id]
  private_dns_enabled = true

  tags = merge({
    Name = "sts-endpoint-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
    Purpose = "aws-cli-authentication"
  }, local.common_tags)
}

#---------------------------------------
# 一時的なS3バケット (DB復旧処理用)
#---------------------------------------
# 目的: us-east-1のS3バケットデータをus-west-2にコピーし、
#       プライベートサブネットのEC2からVPCエンドポイント経由でアクセス可能にする
#
# 理由:
# - EC2インスタンス: us-west-2プライベートサブネット
# - 元データ: us-east-1のS3バケット
# - VPCエンドポイントは同一リージョンのみサポート
# - インターネット接続なし（セキュリティ要件）

# 一時的なS3バケット (us-west-2)
resource "aws_s3_bucket" "temp_db_restore_bucket" {
  bucket = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-temp-db-restore-20250927"

  tags = merge({
    Name        = "temp-db-restore-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
    Purpose     = "temporary-db-restore"
    DeleteAfter = "db-restore-complete"
    CostCenter  = "development-temporary"
  }, local.common_tags)

  lifecycle {
    prevent_destroy = false  # 一時的なので削除を許可
  }
}

# バケットのバージョニング無効化 (一時的なので不要)
resource "aws_s3_bucket_versioning" "temp_db_restore_versioning" {
  bucket = aws_s3_bucket.temp_db_restore_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

# パブリックアクセスブロック (セキュリティ強化)
resource "aws_s3_bucket_public_access_block" "temp_db_restore_pab" {
  bucket = aws_s3_bucket.temp_db_restore_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
