#------------------------------------------------------------------------------
# 3. AWS Database Services
#------------------------------------------------------------------------------

#---------------------------------------
# 3.1  Postgresql 13
#---------------------------------------
resource "aws_db_instance" "rds_instance" {
  identifier             = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-db-v2"
  allocated_storage      = 40  # 本番環境に合わせて40GBに変更
  engine                 = "postgres"
  engine_version         = "13.20"                      # 本番環境と合わせてPostgreSQL 13を使用
  instance_class         = "db.t3.micro"                # 開発環境用（コスト重視）
  # instance_class         = "db.t3.xlarge"             # 本番環境用（4vCPU, 16GB RAM）- 必要に応じてコメントアウト
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres13"         # PostgreSQL 13用のデフォルトパラメータグループ

  # Security improvements - Encryption (no downtime)
  storage_encrypted      = true

  # Security improvements - Snapshot protection
  skip_final_snapshot      = false
  final_snapshot_identifier = "${local.app_identifier}-${local.environment}-final-snapshot"

  # Security improvements - Access control
  publicly_accessible    = false

  # Disable automatic version upgrades
  auto_minor_version_upgrade = false

  # Backup configuration (本番環境に合わせる)
  backup_retention_period = 5                    # 5日間保持（本番と同じ）
  backup_window          = "13:15-13:45"        # UTC時間（本番と同じ）

  # Maintenance window (本番環境に合わせる)
  maintenance_window     = "sat:16:20-sat:16:50" # UTC時間（土曜日 01:20-01:50 JST）

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.id
  tags                   = local.common_tags

  # lifecycle {
  #   prevent_destroy = true  # Prevent accidental deletion of RDS instance
  # }
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