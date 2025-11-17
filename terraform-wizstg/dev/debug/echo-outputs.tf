#===============================================
# Echo Server Outputs
#===============================================

output "echo_lambda_function_name" {
  description = "Echo Lambda関数名"
  value       = aws_lambda_function.echo_function.function_name
}

output "echo_lambda_function_arn" {
  description = "Echo Lambda関数ARN"
  value       = aws_lambda_function.echo_function.arn
}

output "echo_target_group_arn" {
  description = "Echo用ターゲットグループARN"
  value       = aws_lb_target_group.echo_lambda_tg.arn
}

output "echo_endpoint_url" {
  description = "エコーサーバーのエンドポイントURL"
  value       = "http://${data.terraform_remote_state.dev.outputs.alb_dns_name}/echo"
}

output "echo_cloudwatch_log_group" {
  description = "Echo Lambda CloudWatchロググループ"
  value       = aws_cloudwatch_log_group.echo_lambda_logs.name
}