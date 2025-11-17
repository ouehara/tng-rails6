# ECR リポジトリのURLを出力（devから参照される）
output "ecr_repository_url" {
  description = "ECR リポジトリのURL"
  value       = aws_ecr_repository.app_ecr.repository_url
}
