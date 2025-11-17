# ECR リポジトリのURLを出力（devから参照される）
output "ecr_repository_url" {
  description = "ECR リポジトリのURL"
  value       = aws_ecr_repository.app_ecr.repository_url
}

# GitHub Actions IAMロール名を出力（環境別リソースから参照される）
output "github_actions_role_name" {
  description = "GitHub Actions IAMロール名"
  value       = aws_iam_role.github_actions_role.name
}
