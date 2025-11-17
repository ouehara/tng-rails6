#===============================================
# ALB Listener Rules for Echo Server
#
# 既存のALBに /echo パス用のルールを追加
#===============================================

#-----------------------------------------------
# Target Group for Lambda Function
#-----------------------------------------------
resource "aws_lb_target_group" "echo_lambda_tg" {
  name        = "${local.app_identifier}-${local.environment}-echo-tg"
  target_type = "lambda"

  # Lambda target groupの場合、vpc_idは不要
  # port, protocol, health_checkも不要

  tags = merge(local.common_tags, {
    Purpose = "echo-server-lambda"
    Type    = "debug-utility"
  })
}

#-----------------------------------------------
# Lambda Permission for Target Group
#-----------------------------------------------
resource "aws_lambda_permission" "echo_lambda_alb_invoke" {
  statement_id  = "AllowExecutionFromTargetGroup"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.echo_function.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.echo_lambda_tg.arn
}

#-----------------------------------------------
# Target Group Attachment
#-----------------------------------------------
resource "aws_lb_target_group_attachment" "echo_lambda_attachment" {
  target_group_arn = aws_lb_target_group.echo_lambda_tg.arn
  target_id        = aws_lambda_function.echo_function.arn
  depends_on       = [aws_lambda_permission.echo_lambda_alb_invoke]
}

#-----------------------------------------------
# ALB Listener Rule for Echo Path
#-----------------------------------------------
resource "aws_lb_listener_rule" "echo_path_rule_http" {
  listener_arn = data.terraform_remote_state.dev.outputs.alb_listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.echo_lambda_tg.arn
  }

  condition {
    path_pattern {
      values = ["/echo", "/echo/*"]
    }
  }

  tags = merge(local.common_tags, {
    Purpose = "echo-server-routing-http"
    Type    = "debug-utility"
  })
}