#------------------------------------------------------------------------------
# 3. AWS Database Services
#------------------------------------------------------------------------------

#---------------------------------------
# 3.1  Postgresql 13
#---------------------------------------
resource "aws_db_instance" "rds_instance" {
  identifier             = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-db-v2"
  snapshot_identifier    = "rds:w-rails-0930-dev-apn1-db-v2-2025-09-30-03-18"
  allocated_storage      = 40  # 本番環境に合わせて40GBに変更
  engine                 = "postgres"
  engine_version         = "13.20"                      # 本番環境と合わせてPostgreSQL 13を使用
  instance_class         = "db.t3.micro"                # 開発環境用（コスト重視）
  # instance_class         = "db.t3.xlarge"             # 本番環境用（4vCPU, 16GB RAM）- 必要に応じてコメントアウト
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  # parameter_group_name   = "default.postgres13"       # デフォルトパラメータグループ（開発用）
  parameter_group_name   = "default.postgres13"    

  # Security improvements - Encryption (no downtime)
  storage_encrypted      = true

  # Security improvements - Snapshot protection
  skip_final_snapshot      = false
  final_snapshot_identifier = "${local.app_identifier}-${local.environment}-final-snapshot"

  # Security improvements - Access control
  publicly_accessible    = false

  # Auto minor version upgrade (本番環境と同じく有効にする)
  auto_minor_version_upgrade = true    # 本番環境に合わせて有効化

  # Backup configuration (本番環境に合わせる)
  backup_retention_period = 3                    # 3日間保持（本番と同じ）
  backup_window          = "13:15-13:45"        # UTC時間（本番と同じ）

  # Maintenance window (本番環境に合わせる)
  maintenance_window     = "wed:16:20-wed:16:50" # UTC時間（木曜日 01:20-01:50 JST） - 本番と同じ

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.id
  tags                   = local.common_tags

  # Deletion protection (本番環境と同じく有効)
  deletion_protection = true   # 誤削除防止（本番と同じ）

  # lifecycle {
  #   prevent_destroy = true  # Prevent accidental deletion of RDS instance
  # }
}

#---------------------------------------
# 3.2 Temporary DB for snapshot restore
#---------------------------------------
resource "aws_db_instance" "rds_temp" {
  identifier             = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-db-temp"
  snapshot_identifier    = "rds:w-rails-0930-dev-apn1-db-v2-2025-09-30-03-18"
  allocated_storage      = 40
  engine                 = "postgres"
  engine_version         = "13.20"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres13"

  # Security settings
  storage_encrypted      = true
  skip_final_snapshot    = true  # 一時DBなのでfinal snapshot不要
  publicly_accessible    = false
  auto_minor_version_upgrade = true

  # Backup settings
  backup_retention_period = 3
  backup_window          = "13:15-13:45"
  maintenance_window     = "wed:16:20-wed:16:50"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.id
  tags = merge(local.common_tags, {
    Name = "Temporary DB for snapshot restore"
    Purpose = "db-recovery"
  })

  # 一時DBなので削除保護は無効
  deletion_protection = false
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-dbsubnet"
  subnet_ids = aws_subnet.private_subnet[*].id
  tags       = local.common_tags
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
  description = "RDS Security Group"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}