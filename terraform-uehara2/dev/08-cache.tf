#===============================================
# ElastiCache Memcached Configuration
# 
# Railsアプリケーション用Memcachedクラスター
# - 最小限の設定でコスト効率的な構成
# - キャッシュ用途：データベースクエリ結果、セッション、計算結果
# - セキュリティ：プライベートサブネット内での動作
#===============================================

#-----------------------------------------------
# ElastiCache Subnet Group
# 
# Memcachedクラスターが動作するサブネットグループ
# - プライベートサブネット内でのみ動作（セキュリティ強化）
# - 複数AZでの高可用性確保
#-----------------------------------------------
resource "aws_elasticache_subnet_group" "memcached_subnet_group" {
  name       = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-memcached-subnet-group"
  subnet_ids = aws_subnet.private_subnet[*].id

  tags = merge({
    Name    = "elasticache-subnet-group-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
    Purpose = "memcached-subnet-group"
  }, local.common_tags)
}

#-----------------------------------------------
# Security Group for ElastiCache Memcached
# 
# Memcachedクラスター用のセキュリティグループ
# - ECSタスクからのアクセスのみ許可（ポート11211）
# - 最小権限の原則に従ったアクセス制御
#-----------------------------------------------
resource "aws_security_group" "memcached_sg" {
  name        = "memcached-sg-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
  description = "Security group for ElastiCache Memcached cluster"
  vpc_id      = aws_vpc.vpc.id

  # ECSタスクからのMemcachedアクセス（ポート11211）を許可
  ingress {
    from_port       = 11211
    to_port         = 11211
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
    description     = "Allow Memcached access from ECS tasks"
  }

  # アウトバウンド通信は特に制限しない（レスポンス用）
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge({
    Name    = "sg-memcached-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
    Purpose = "memcached-access-control"
  }, local.common_tags)
}

#-----------------------------------------------
# ElastiCache Parameter Group
# 
# Memcached用のパラメータグループ
# 
# 【本番環境との比較】
# Production: "default.memcached1.4" (AWS管理、パラメータ150個)
#   - family: memcached1.4
#   - 主要パラメータ例:
#     * backlog_queue_limit: 1024
#     * binding_protocol: auto
#     * chunk_size: 48
#     * chunk_size_growth_factor: 1.25
#     * disable_flush_all: 0
#     * error_on_memory_exhausted: 0
#     * max_item_size: 1048576 (1MB)
# 
# Development: カスタムパラメータグループ
#   - family: memcached1.6 (新しいエンジン用)
#   - 最小限の設定（必要に応じて追加可能）
#-----------------------------------------------
resource "aws_elasticache_parameter_group" "memcached_params" {
  family = "memcached1.6"  # 本番: memcached1.4
  name   = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-memcached-params"

  # 基本的なMemcachedパラメータ設定
  parameter {
    name  = "max_item_size"
    value = "1048576"  # 1MB（本番環境と同じ、デフォルト値）
  }
  
  # 本番環境で重要なパラメータ例（必要に応じてコメントアウト解除）:
  # parameter {
  #   name  = "chunk_size"
  #   value = "48"  # 本番環境と同じ
  # }
  # parameter {
  #   name  = "chunk_size_growth_factor" 
  #   value = "1.25"  # 本番環境と同じ
  # }
  # parameter {
  #   name  = "disable_flush_all"
  #   value = "0"  # 本番環境と同じ
  # }

  tags = merge({
    Name    = "elasticache-params-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
    Purpose = "memcached-parameters"
  }, local.common_tags)
}

#-----------------------------------------------
# ElastiCache Memcached Cluster
# 
# メインのMemcachedクラスター
# 
# 【本番環境との比較】
# Production (tng-prod):
#   - cluster_id: "tng-prod"
#   - engine_version: "1.4.34" 
#   - node_type: "cache.r5.large" (13.07GB RAM, メモリ最適化)
#   - num_cache_nodes: 1
#   - parameter_group: "default.memcached1.4"
#   - endpoint: "tng-prod.n9kn0v.cfg.apne1.cache.amazonaws.com:11211"
#   - arn: "arn:aws:elasticache:ap-northeast-1:412742703218:cluster:tng-prod"
#   - created: July 20, 2017
#   - region: ap-northeast-1
#
# Development (this configuration):
#   - cluster_id: "v-rails6-dev-uswest2-memcached"
#   - engine_version: "1.6.22" (最新安定版、セキュリティ強化)
#   - node_type: "cache.t3.micro" (0.5GB RAM, コスト効率重視)
#   - num_cache_nodes: 1
#   - parameter_group: カスタム (memcached1.6)
#   - region: us-west-2
#
# 🔍 主な差異:
#   1. エンジンバージョン: 1.4.34 → 1.6.22 (セキュリティ・機能向上)
#   2. ノードタイプ: r5.large → t3.micro (メモリ 13GB → 0.5GB)
#   3. パラメータグループ: default → カスタム
#   4. リージョン: ap-northeast-1 → us-west-2
#-----------------------------------------------
resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-memcached"
  engine               = "memcached"
  engine_version       = "1.6.22"         # 本番: 1.4.34
  node_type            = "cache.t3.micro"  # 本番: cache.r5.large (13.07GB) vs 開発: cache.t3.micro (0.5GB)
  num_cache_nodes      = 1                 # 本番と同じ
  parameter_group_name = aws_elasticache_parameter_group.memcached_params.id  # 本番: default.memcached1.4
  port                 = 11211                                                     # 本番と同じ
  subnet_group_name    = aws_elasticache_subnet_group.memcached_subnet_group.id
  security_group_ids   = [aws_security_group.memcached_sg.id]

  # メンテナンス設定
  maintenance_window = "sun:05:00-sun:06:00"  # 日曜日の午前5-6時（JST 14-15時）
  
  # 本番環境設定例（参考用、コメントアウト）:
  # 本番環境で同等構成にする場合は以下を使用
  # cluster_id           = "tng-prod"
  # engine_version       = "1.4.34"
  # node_type            = "cache.r5.large"
  # parameter_group_name = "default.memcached1.4"
  # maintenance_window   = "sun:05:00-sun:06:00" # 本番では設定不明

  # 通知設定（オプション）
  # notification_topic_arn = aws_sns_topic.elasticache_notifications.arn

  tags = merge({
    Name    = "elasticache-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
    Purpose = "memcached-cluster"
  }, local.common_tags)

  depends_on = [
    aws_elasticache_subnet_group.memcached_subnet_group,
    aws_security_group.memcached_sg
  ]
}
