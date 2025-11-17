#---------------------------------------
# ECS Batch Tasks
#---------------------------------------

# バッチタスク用CloudWatch Logsグループ
resource "aws_cloudwatch_log_group" "rails_batch_logs" {
  name              = "/ecs/${local.app_identifier}-${local.environment}-${local.aws_region_string}-batch-tasks"
  retention_in_days = 30
  tags              = local.common_tags
}

#---------------------------------------
# Batch Task Definitions
#---------------------------------------

# xml:articles用ECSタスク定義
resource "aws_ecs_task_definition" "rails_batch_xml_articles" {
  family                   = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-batch-xml-articles"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "rails-batch-container"
      image     = "${local.ecr_repository_url}:dev-latest"
      essential = true
      command   = ["bundle", "exec", "rails", "xml:articles"]

      environment = [
        {
          name  = "SKIP_MIGRATION"
          value = "true"
        },
        {
          name  = "SECRET_KEY_BASE"
          value = var.rails_secret_key_base
        },
        {
          name  = "DATABASE_URL"
          value = "postgres://${var.db_username}:${var.db_password}@${aws_db_instance.rds_instance.address}:5432/${var.db_name}"
        },
        {
          name  = "RDS_USER_NAME"
          value = var.db_username
        },
        {
          name = "RDS_HOST_NAME"
          value = "${aws_db_instance.rds_instance.address}"
        },
        {
          name ="RDS_DB_NAME"
          value = var.db_name
        },
        {
          name = "RDS_DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "RAILS_ENV"
          value = "production"
        },
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "TNG_AWS_ACCESS_KEY_ID"
          value = aws_iam_access_key.s3_static_assets_access_key.id
        },
        {
          name  = "TNG_AWS_SECRET_ACCESS_KEY"
          value = aws_iam_access_key.s3_static_assets_access_key.secret
        },
        {
          name  = "TNG_S3_BUCKET"
          value = aws_s3_bucket.static_assets.bucket
        },
        {
          name  = "TNG_AWS_S3_REGION"
          value = local.aws_region
        },
        {
          name  = "CLOUDFRONT_DOMAIN"
          value = aws_cloudfront_distribution.s3_distribution.domain_name
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.rails_batch_logs.id
          awslogs-region        = local.aws_region
          awslogs-stream-prefix = "xml-articles"
        }
      }
    }
  ])

  tags = local.common_tags
}

# sitemap:refresh用ECSタスク定義
resource "aws_ecs_task_definition" "rails_batch_sitemap_refresh" {
  family                   = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-batch-sitemap-refresh"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "rails-batch-container"
      image     = "${local.ecr_repository_url}:dev-latest"
      essential = true
      command   = ["bundle", "exec", "rails", "sitemap:refresh"]

      environment = [
        {
          name  = "SKIP_MIGRATION"
          value = "true"
        },
        {
          name  = "SECRET_KEY_BASE"
          value = var.rails_secret_key_base
        },
        {
          name  = "DATABASE_URL"
          value = "postgres://${var.db_username}:${var.db_password}@${aws_db_instance.rds_instance.address}:5432/${var.db_name}"
        },
        {
          name  = "RDS_USER_NAME"
          value = var.db_username
        },
        {
          name = "RDS_HOST_NAME"
          value = "${aws_db_instance.rds_instance.address}"
        },
        {
          name ="RDS_DB_NAME"
          value = var.db_name
        },
        {
          name = "RDS_DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "RAILS_ENV"
          value = "production"
        },
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "CLOUDFRONT_DOMAIN"
          value = aws_cloudfront_distribution.s3_distribution.domain_name
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.rails_batch_logs.id
          awslogs-region        = local.aws_region
          awslogs-stream-prefix = "sitemap-refresh"
        }
      }
    }
  ])

  tags = local.common_tags
}

# missing_images:check_articles用ECSタスク定義
resource "aws_ecs_task_definition" "rails_batch_missing_images" {
  family                   = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-batch-missing-images"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "rails-batch-container"
      image     = "${local.ecr_repository_url}:dev-latest"
      essential = true
      command   = ["bundle", "exec", "rails", "missing_images:check_articles"]

      environment = [
        {
          name  = "SKIP_MIGRATION"
          value = "true"
        },
        {
          name  = "SECRET_KEY_BASE"
          value = var.rails_secret_key_base
        },
        {
          name  = "DATABASE_URL"
          value = "postgres://${var.db_username}:${var.db_password}@${aws_db_instance.rds_instance.address}:5432/${var.db_name}"
        },
        {
          name  = "RDS_USER_NAME"
          value = var.db_username
        },
        {
          name = "RDS_HOST_NAME"
          value = "${aws_db_instance.rds_instance.address}"
        },
        {
          name ="RDS_DB_NAME"
          value = var.db_name
        },
        {
          name = "RDS_DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "RAILS_ENV"
          value = "production"
        },
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "CLOUDFRONT_DOMAIN"
          value = aws_cloudfront_distribution.s3_distribution.domain_name
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.rails_batch_logs.id
          awslogs-region        = local.aws_region
          awslogs-stream-prefix = "missing-images"
        }
      }
    }
  ])

  tags = local.common_tags
}

