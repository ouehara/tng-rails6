# Data sources for temporary DB restore resources
# 既存のVPCとサブネット情報を参照

# VPCとサブネットの情報はdev環境のremote stateから取得
# data "aws_vpc" と data "aws_subnets" は不要（remote stateで代替）


# RDS情報もdev環境のremote stateから取得
# data "aws_db_instance" は不要（remote stateで代替）