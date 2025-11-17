#------------------------------------------------------------------------------
# 2. AWS Network Services
#------------------------------------------------------------------------------

#---------------------------------------
# 2.1  VPC,Subnet
#---------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge({
    Name = "vpc-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
  }, local.common_tags)
}

# IWGE
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge({
    Name = "igw-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
  }, local.common_tags)
}

#---------------------------

# Privateサブネット
resource "aws_subnet" "private_subnet" {
  count             = length(local.availability_zones)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + length(local.availability_zones))
  availability_zone = local.availability_zones[count.index]
  tags = merge({
    Name = "private-subnet-${local.app_identifier}-${local.environment}-${local.aws_region_string}-${count.index}"
  }, local.common_tags)
}

# Privateサブネットのルートテーブル定義
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-rt-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
  }
}

resource "aws_route_table_association" "private_rta" {
  count          = length(local.availability_zones)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# ECR API エンドポイント(ECR の認証トークン取得)
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${local.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private_subnet[*].id
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true  #  DNS 名を有効化
}

# ECR Docker レジストリエンドポイント(ECR からの docker pull)
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${local.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private_subnet[*].id
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true
}

# CloudWatch Logs エンドポイント
resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${local.aws_region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private_subnet[*].id
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${local.aws_region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private_subnet[*].id
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${local.aws_region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private_subnet[*].id
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${local.aws_region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private_subnet[*].id
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true
}

# S3 へのエンドポイント (ECRは内部的にS3を利用しているため、ECRからのイメージPULLに必要)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${local.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_rt.id]
}

# VPCエンドポイント用のセキュリティグループ作成
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-sg-${local.app_identifier}-${local.environment}-${local.aws_region_string}"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}