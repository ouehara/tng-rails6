#===============================================
# ECS Configuration
#
# Container orchestration and task management
# Dependencies:
# - IAM roles (iam.tf)
# - RDS instance (database.tf)
# - S3 bucket (static-assets-s3.tf)
# - VPC/subnets (network.tf)
#===============================================

#---------------------------------------
# ECS CloudWatch Logs
#---------------------------------------

resource "aws_cloudwatch_log_group" "ecs_task_logs" {
  name              = "/ecs/${local.app_identifier}-${local.environment}-${local.aws_region_string}-task"
  retention_in_days = 7
  tags              = local.common_tags
}

#---------------------------------------
# ECS Cluster
#---------------------------------------

resource "aws_ecs_cluster" "app_cluster" {
  name = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-cluster"
  tags = local.common_tags

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  setting {
    name  = "containerInsights"
    value = "enhanced"
  }
}

#---------------------------------------
# ECS Task Definition
#---------------------------------------

resource "aws_ecs_task_definition" "rails_app_task" {
  family                   = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-rails-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "4096"  # 2048→1024 (コスト最適化: 開発環境用)
  memory                   = "8192"  # 8192→2048 (メモリ使用率7%以下のため大幅削減)
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  tags                     = local.common_tags
  container_definitions = jsonencode([
    {
      name      = "rails-app-container"
      image     = "${local.ecr_repository_url}:dev-latest" # prodは "prod-latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000,
          hostPort      = 3000
        }
      ]
      environment = [
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
          # name  = "DATABASE_HOST"
          name = "RDS_HOST_NAME"
          value = "${aws_db_instance.rds_instance.address}"
        },
        {
          # name  = "DATABASE_USERNAME"
          name ="RDS_DB_NAME"
          value = var.db_name
        },
        {
          # name  = "DATABASE_PASSWORD"
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
          name  = "DEBUG_MODE"
          value = "False"
        },
        {
          name  = "RAILS_MAX_THREADS"
          value = "4"  # 4 threads per worker
        },
        {
          name  = "DB_POOL"
          value = "22"  # 5 workers × 4 threads + 2 overhead
        },
        {
          name  = "WEB_CONCURRENCY"
          value = "5"  # 5 workers (並列度 = 5×4 = 20)
        },
        # AWS S3/Paperclip Configuration
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
        # Email/Mailer Configuration
        {
          name  = "TNG_SENDER_USERNAME"
          value = "your_smtp_username"  # TODO: Replace with actual SMTP username
        },
        {
          name  = "TNG_SENDER_PASSWORD"
          value = "your_smtp_password"  # TODO: Replace with actual SMTP password
        },
        {
          name  = "TNG_SENDER_DOMAIN"
          value = "your_smtp_domain"  # TODO: Replace with actual SMTP domain
        },
        {
          name  = "TNG_SENDER_ADDRESS"
          value = var.noreply_email
        },
        # Social Authentication (Optional)
        {
          name  = "TNG_FACEBOOK_APP_ID"
          value = "your_facebook_app_id"  # TODO: Replace with actual Facebook app ID
        },
        {
          name  = "TNG_FACEBOOK_APP_SECRET"
          value = "your_facebook_app_secret"  # TODO: Replace with actual Facebook app secret
        },
        # Twitter API (Optional)
        {
          name  = "TNG_TWITTER_CONSUMER_KEY"
          value = "your_twitter_consumer_key"  # TODO: Replace with actual Twitter consumer key
        },
        {
          name  = "TNG_TWITTER_CONSUMER_SECRET"
          value = "your_twitter_consumer_secret"  # TODO: Replace with actual Twitter consumer secret
        },
        # Memcached Configuration
        {
          name  = "MEMCACHED_ENDPOINT"
          value = aws_elasticache_cluster.memcached.cache_nodes[0].address
        },
        {
          name  = "MEMCACHED_PORT"
          value = tostring(aws_elasticache_cluster.memcached.port)
        },
        # CloudFront Configuration
        {
          name  = "CLOUDFRONT_DOMAIN"
          value = aws_cloudfront_distribution.s3_distribution.domain_name
        },
        {
          name  = "CLOUDFRONT_DISTRIBUTION_ID"
          value = aws_cloudfront_distribution.s3_distribution.id
        },
        # CloudSearch Configuration
        {
          name  = "TNG_CLOUD_SEARCH_ENDPOINT_DOCUMENT"
          value = "your_cloudsearch_document_endpoint"  # TODO: Replace with actual CloudSearch document endpoint
        },
        {
          name  = "TNG_CLOUD_SEARCH_ENDPOINT_SEARCH"
          value = "your_cloudsearch_search_endpoint"    # TODO: Replace with actual CloudSearch search endpoint
        },
        {
          name  = "SKIP_MIGRATION"
          value = "false"
        },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_task_logs.id
          awslogs-region        = local.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  # ECSタスク定義のrevisionは常に変わるため、Terraformの差分を無視
  lifecycle {
    ignore_changes = [
      # revision
    ]
  }
}

#---------------------------------------
# ECS Service
#---------------------------------------

resource "aws_ecs_service" "rails_app_service" {
  name            = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.rails_app_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  enable_execute_command = true

  health_check_grace_period_seconds = 120  # 2分 - 立ち上がり時間を考慮

  network_configuration {
    subnets         = aws_subnet.private_subnet[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false  # Private Subnetで動作
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "rails-app-container"
    container_port   = 3000
  }

  # オートスケーリングによる変更を無視
  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = local.common_tags
}

#---------------------------------------
# Auto Scaling Configuration
#---------------------------------------

# Auto Scaling Target
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 5
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.app_cluster.name}/${aws_ecs_service.rails_app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  tags = local.common_tags
}

# CPU使用率によるスケールアウト
resource "aws_appautoscaling_policy" "ecs_scale_out_cpu" {
  name               = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-scale-out-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 30.0  # CPU使用率30%でスケールアウト(早めにスケールアウトするため)
    scale_out_cooldown = 90   # ECS起動(60秒) + 30秒のクールダウン
    scale_in_cooldown  = 180   # 1.5分のクールダウン
  }
  # depends_on = [
  #   aws_ecs_service.rails_app_service
  # ]
}

## メモリに余力があるのでメモリ使用率によるスケールアウトは不要
# # メモリ使用率によるスケールアウト
# resource "aws_appautoscaling_policy" "ecs_scale_out_memory" {
#   name               = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-scale-out-memory"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.ecs_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageMemoryUtilization"
#     }
#     target_value       = 80.0  # メモリ使用率80%でスケールアウト
#     scale_out_cooldown = 300   # 5分のクールダウン
#     scale_in_cooldown  = 300   # 5分のクールダウン
#   }
# }