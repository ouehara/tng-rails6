# Locals for temporary DB restore resources
# これらの値は ../main.tf から抽出されたものです

locals {
  common_tags = {
    Owner       = var.owner_tag
    Environment = var.environment
    App         = var.app_identifier
  }
  aws_region = var.aws_region
  aws_region_string = "apn1"  # リージョン名をハイフン無しで整形
  app_identifier = var.app_identifier
  environment = var.environment
  availability_zones = var.availability_zones
}