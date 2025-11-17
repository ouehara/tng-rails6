#------------------------------------------------------------------------------
# 1.5 GitHub Actions S3 Permissions
#------------------------------------------------------------------------------

# commonで作成されたGitHub ActionsロールにS3権限を追加
resource "aws_iam_policy" "github_actions_s3_assets_policy" {
  name        = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-github-actions-s3-assets-policy"
  description = "GitHub Actions S3 assets upload policy for ${var.environment} environment"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.static_assets.arn,
          "${aws_s3_bucket.static_assets.arn}/*"
        ]
      }
    ]
  })

  tags = merge({
    Name    = "iam-policy-${local.app_identifier}-${local.environment}-${local.aws_region_string}-github-actions-s3-assets"
    Purpose = "github-actions-s3-assets-access"
  }, local.common_tags)
}

# commonで作成されたGitHub ActionsロールにS3権限をアタッチ
resource "aws_iam_role_policy_attachment" "github_actions_s3_assets" {
  role       = data.terraform_remote_state.common.outputs.github_actions_role_name
  policy_arn = aws_iam_policy.github_actions_s3_assets_policy.arn
}

#------------------------------------------------------------------------------
# 4.1  ECS実行IAMロール作成
#------------------------------------------------------------------------------

resource "aws_iam_role" "ecs_execution_role" {
  name               = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  # IAM ポリシーの競合を避ける（不要なポリシーがある場合に強制解除）
  force_detach_policies = true

  tags = local.common_tags
}

# 最小権限のCloudWatch Logsポリシーを作成
resource "aws_iam_policy" "ecs_cloudwatch_logs_limited" {
  name        = "${local.app_identifier}-${local.environment}-ecs-cloudwatch-logs-limited"
  description = "Limited CloudWatch Logs permissions for ECS tasks"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.ecs_task_logs.arn}:*"
      }
    ]
  })

  tags = merge({
    Name    = "ecs-cloudwatch-logs-limited"
    Purpose = "ecs-logging"
  }, local.common_tags)
}

# 限定的CloudWatch Logs権限をECSタスク実行ロールにアタッチ
resource "aws_iam_role_policy_attachment" "ecs_execution_role_cloudwatch_logs" {
  role       = aws_iam_role.ecs_execution_role.id
  policy_arn = aws_iam_policy.ecs_cloudwatch_logs_limited.arn
}

# AWS管理ポリシーをアタッチ (ECR実行権限)
resource "aws_iam_role_policy_attachment" "ecs_execution_role_attach" {
  role      = aws_iam_role.ecs_execution_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# AWS管理ポリシーをアタッチ (ECR 読み取り専用)
resource "aws_iam_role_policy_attachment" "ecs_execution_role_ecr_attach" {
  role      = aws_iam_role.ecs_execution_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# ECS Execを使いたいので、AWS Systems Manager (SSM) を利用する
resource "aws_iam_role_policy_attachment" "ecs_execution_role_ssm" {
  role      = aws_iam_role.ecs_execution_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ECS タスク用の IAM ロール
resource "aws_iam_role" "ecs_task_role" {
  name = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = local.common_tags
}

# 最小権限のSSMポリシーを作成（ECS Exec専用）
resource "aws_iam_policy" "ecs_ssm_exec_limited" {
  name        = "${local.app_identifier}-${local.environment}-ecs-ssm-exec-limited"
  description = "Limited SSM permissions for ECS Exec functionality"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge({
    Name    = "ecs-ssm-exec-limited"
    Purpose = "ecs-exec-only"
  }, local.common_tags)
}

# 限定的SSM権限をECSタスクロールにアタッチ
resource "aws_iam_role_policy_attachment" "ecs_task_role_attach" {
  role       = aws_iam_role.ecs_task_role.id
  policy_arn = aws_iam_policy.ecs_ssm_exec_limited.arn
}

# ECS Exec用のSSMセッションマネージャー権限
resource "aws_iam_role_policy_attachment" "ecs_task_role_ssm_exec" {
  role       = aws_iam_role.ecs_task_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}