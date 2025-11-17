# バッチスケジューラー（EventBridge）
# ECSバッチタスクの定期実行スケジュール管理

#---------------------------------------
# IAM Roles for EventBridge
#---------------------------------------

resource "aws_iam_role" "eventbridge_ecs_role" {
  name = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-eventbridge-ecs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "eventbridge_ecs_policy" {
  name = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-eventbridge-ecs-policy"
  role = aws_iam_role.eventbridge_ecs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:RunTask"
        ]
        Resource = [
          "${aws_ecs_task_definition.rails_batch_xml_articles.arn_without_revision}:*",
          "${aws_ecs_task_definition.rails_batch_sitemap_refresh.arn_without_revision}:*",
          "${aws_ecs_task_definition.rails_batch_missing_images.arn_without_revision}:*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = [
          aws_iam_role.ecs_execution_role.arn,
          aws_iam_role.ecs_task_role.arn
        ]
      }
    ]
  })
}

#---------------------------------------
# EventBridge Rules and Targets
#---------------------------------------

# XML記事バッチ（毎月20日8時JST）
resource "aws_cloudwatch_event_rule" "xml_articles_schedule" {
  name                = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-xml-articles-schedule"
  description         = "Schedule for XML articles batch processing"
  schedule_expression = "cron(0 23 20 * ? *)"  # 毎月20日8時JST（UTC 23時）
  tags                = local.common_tags
}

resource "aws_cloudwatch_event_target" "xml_articles_target" {
  rule      = aws_cloudwatch_event_rule.xml_articles_schedule.id
  target_id = "XmlArticlesBatchTarget"
  arn       = aws_ecs_cluster.app_cluster.arn
  role_arn  = aws_iam_role.eventbridge_ecs_role.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.rails_batch_xml_articles.arn
    launch_type         = "FARGATE"
    platform_version    = "LATEST"

    network_configuration {
      subnets          = aws_subnet.private_subnet[*].id
      security_groups  = [aws_security_group.ecs_sg.id]
      assign_public_ip = false
    }
  }
}

# サイトマップ更新バッチ（毎日0時JST）
resource "aws_cloudwatch_event_rule" "sitemap_refresh_schedule" {
  name                = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-sitemap-refresh-schedule"
  description         = "Schedule for sitemap refresh batch processing"
  schedule_expression = "cron(0 15 * * ? *)"  # 毎日0時JST（UTC 15時）
  tags                = local.common_tags
}

resource "aws_cloudwatch_event_target" "sitemap_refresh_target" {
  rule      = aws_cloudwatch_event_rule.sitemap_refresh_schedule.id
  target_id = "SitemapRefreshBatchTarget"
  arn       = aws_ecs_cluster.app_cluster.arn
  role_arn  = aws_iam_role.eventbridge_ecs_role.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.rails_batch_sitemap_refresh.arn
    launch_type         = "FARGATE"
    platform_version    = "LATEST"

    network_configuration {
      subnets          = aws_subnet.private_subnet[*].id
      security_groups  = [aws_security_group.ecs_sg.id]
      assign_public_ip = false
    }
  }
}

# 画像不足チェックバッチ（毎週月曜10:32 JST）
resource "aws_cloudwatch_event_rule" "missing_images_schedule" {
  name                = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-missing-images-schedule"
  description         = "Schedule for missing images check batch processing"
  schedule_expression = "cron(32 1 ? * MON *)"  # 毎週月曜10:32 JST（UTC 1:32）
  tags                = local.common_tags
}

resource "aws_cloudwatch_event_target" "missing_images_target" {
  rule      = aws_cloudwatch_event_rule.missing_images_schedule.id
  target_id = "MissingImagesBatchTarget"
  arn       = aws_ecs_cluster.app_cluster.arn
  role_arn  = aws_iam_role.eventbridge_ecs_role.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.rails_batch_missing_images.arn
    launch_type         = "FARGATE"
    platform_version    = "LATEST"

    network_configuration {
      subnets          = aws_subnet.private_subnet[*].id
      security_groups  = [aws_security_group.ecs_sg.id]
      assign_public_ip = false
    }
  }
}