# DB復旧手順（簡易版）

## 概要
スナップショットからDBを完全復元。約30分のダウンタイム発生。

## 手順

### 1. 一時DB作成
```bash
cd /Users/sukejima/Desktop/wizgeek2/develop/tng-rails6/terraform/dev
export AWS_PROFILE=904271084068tokyo
terraform apply -var-file=terraform_dev.tfvars -target=aws_db_instance.rds_temp
```
**確認**: `"available"` が表示されるまで待つ（10-15分）
```bash
aws rds describe-db-instances --region ap-northeast-1 --db-instance-identifier w-rails-0930-dev-apn1-db-temp --query 'DBInstances[0].DBInstanceStatus'
```

### 2. アプリ停止
```bash
export CLUSTER_NAME=w-rails-0930-dev-apn1-cluster
export SERVICE_NAME=$(aws ecs list-services --region ap-northeast-1 --cluster $CLUSTER_NAME --query 'serviceArns[0]' --output text | cut -d'/' -f3)
echo "サービス名: $SERVICE_NAME"

aws ecs update-service --region ap-northeast-1 --cluster $CLUSTER_NAME --service $SERVICE_NAME --desired-count 0
```

### 3. 古いDB削除
```bash
aws rds delete-db-instance --region ap-northeast-1 --db-instance-identifier w-rails-0930-dev-apn1-db-v2 --skip-final-snapshot
```

### 4. 一時DBを本番名に変更
```bash
aws rds modify-db-instance --region ap-northeast-1 --db-instance-identifier w-rails-0930-dev-apn1-db-temp --new-db-instance-identifier w-rails-0930-dev-apn1-db-v2 --apply-immediately
```

### 5. Terraform管理復帰
```bash
terraform state rm aws_db_instance.rds_instance
terraform import aws_db_instance.rds_instance w-rails-0930-dev-apn1-db-v2
terraform state rm aws_db_instance.rds_temp
```

### 6. アプリ再開
```bash
aws ecs update-service --region ap-northeast-1 --cluster $CLUSTER_NAME --service $SERVICE_NAME --desired-count 1
```
