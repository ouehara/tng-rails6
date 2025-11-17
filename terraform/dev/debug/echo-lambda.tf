#===============================================
# Echo Server Lambda Function
#
# ALBから受信したリクエストをエコーするLambda関数
#===============================================

#-----------------------------------------------
# Lambda Function Archive
#-----------------------------------------------
data "archive_file" "echo_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/test-src/echo-function"
  output_path = "${path.module}/echo-function.zip"
}

#-----------------------------------------------
# IAM Role for Lambda Function
#-----------------------------------------------
resource "aws_iam_role" "echo_lambda_role" {
  name = "${local.app_identifier}-${local.environment}-echo-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

#-----------------------------------------------
# IAM Policy Attachment - Basic Lambda Execution
#-----------------------------------------------
resource "aws_iam_role_policy_attachment" "echo_lambda_basic" {
  role       = aws_iam_role.echo_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#-----------------------------------------------
# Lambda Function
#-----------------------------------------------
resource "aws_lambda_function" "echo_function" {
  filename         = data.archive_file.echo_lambda_zip.output_path
  function_name    = "${local.app_identifier}-${local.environment}-echo-function"
  role            = aws_iam_role.echo_lambda_role.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 128

  source_code_hash = data.archive_file.echo_lambda_zip.output_base64sha256

  environment {
    variables = {
      ENVIRONMENT = local.environment
      APP_NAME    = local.app_identifier
    }
  }

  tags = merge(local.common_tags, {
    Purpose = "request-echo-server"
    Type    = "debug-utility"
  })
}

# Lambda権限設定はalb-rules.tfで管理

#-----------------------------------------------
# CloudWatch Log Group
#-----------------------------------------------
resource "aws_cloudwatch_log_group" "echo_lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.echo_function.function_name}"
  retention_in_days = 7
  tags              = local.common_tags
}