# Terraform基盤構築

## 概要
Terraform を使用してインフラを構築します。本手順は本番環境を前提としていますが、環境変数を変更することで開発環境でも利用可能です。

## 前提条件
- AWS CLI設定済み
- Terraform v1.13.3以上
- 適切なIAM権限

---

## 1. 環境変数設定

本番環境例：
```bash
export APP_ID="v-rails6"
export ENV="prod"
export REGION="ap-northeast-1"
export REGION_SHORT="apn1"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export DATE_SUFFIX=$(date +%m%d)
```

開発環境の場合は `ENV="dev"` に変更してください。

---

## 2. S3バケット作成（Terraform State管理用）

### 2.1 共通リソース用S3バケット
```bash
# バケット名生成
export STATE_BUCKET_COMMON="terraform-state-${ENV}-common-rails-${DATE_SUFFIX}-${AWS_ACCOUNT_ID}"

# バケット作成
aws s3 mb s3://${STATE_BUCKET_COMMON} --region ${REGION}

# バケット設定
aws s3api put-bucket-versioning \
  --bucket ${STATE_BUCKET_COMMON} \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket ${STATE_BUCKET_COMMON} \
  --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'

aws s3api put-public-access-block \
  --bucket ${STATE_BUCKET_COMMON} \
  --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

### 2.2 環境別リソース用S3バケット
```bash
# バケット名生成
export STATE_BUCKET_ENV="terraform-state-${ENV}-rails-${DATE_SUFFIX}-${AWS_ACCOUNT_ID}"

# バケット作成（上記と同じコマンドを STATE_BUCKET_ENV で実行）
aws s3 mb s3://${STATE_BUCKET_ENV} --region ${REGION}
# 以下、バケット設定も同様に実行...
```

---

## 3. 共通リソース作成（ECR + OIDC）

### 3.1 ディレクトリ準備
```bash
# 既存のcommonをリネーム
mv terraform-wizstg/common terraform-wizstg/${ENV}-common
```

### 3.2 Backend設定更新
`terraform-wizstg/${ENV}-common/main.tf` を編集：
```hcl
terraform {
  backend "s3" {
    bucket = "${STATE_BUCKET_COMMON}"  # 実際のバケット名に置換
    key    = "${ENV}-common/terraform.tfstate"
    region = "${REGION}"
    encrypt = true
  }
}
```

### 3.3 実行
```bash
cd terraform-wizstg/${ENV}-common
terraform init
terraform plan -var-file="terraform_${ENV}_common.tfvars"
terraform apply -var-file="terraform_${ENV}_common.tfvars"
```

**作成リソース**:
- ECR: `ecr-${APP_ID}-${ENV}-${REGION_SHORT}`
- GitHub Actions OIDC Provider
- GitHub Actions IAM Role

---

## 4. 環境別インフラ作成

### 4.1 Backend設定更新
`terraform-wizstg/${ENV}/main.tf` を編集：
```hcl
terraform {
  backend "s3" {
    bucket = "${STATE_BUCKET_ENV}"  # 実際のバケット名に置換
    key    = "${ENV}/terraform.tfstate"
    region = "${REGION}"
    encrypt = true
  }
}

# 共通リソース参照
data "terraform_remote_state" "common" {
  backend = "s3"
  config = {
    bucket = "${STATE_BUCKET_COMMON}"  # 実際のバケット名に置換
    key    = "${ENV}-common/terraform.tfstate"
    region = "${REGION}"
  }
}
```

### 4.2 RDSスナップショット復元設定

`terraform-wizstg/${ENV}/06-database.tf` にスナップショット復元機能を追加：

```hcl
# variables.tf に追加
variable "restore_from_snapshot" {
  description = "スナップショットから復元するか"
  type        = bool
  default     = false
}

variable "snapshot_id" {
  description = "復元元のスナップショットID"
  type        = string
  default     = null
}

# 06-database.tf のRDS設定を更新
resource "aws_db_instance" "rds_instance" {
  identifier = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-db"

  # スナップショット復元
  snapshot_identifier = var.restore_from_snapshot ? var.snapshot_id : null

  # 通常設定
  allocated_storage = 40
  engine           = "postgres"
  engine_version   = "13.20"
  instance_class   = "db.t3.xlarge"

  # スナップショット復元時は無視される項目
  db_name  = var.restore_from_snapshot ? null : var.db_name
  username = var.restore_from_snapshot ? null : var.db_username
  password = var.restore_from_snapshot ? null : var.db_password

  # その他の設定...
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.id

  lifecycle {
    ignore_changes = [snapshot_identifier]
  }

  tags = local.common_tags
}
```

### 4.3 実行

**初回（スナップショット復元）**:
```bash
cd terraform-wizstg/${ENV}
terraform init
terraform plan -var-file="terraform_${ENV}.tfvars" \
  -var="restore_from_snapshot=true" \
  -var="snapshot_id=uehara1028-before-renew-wizstg"
terraform apply -var-file="terraform_${ENV}.tfvars" \
  -var="restore_from_snapshot=true" \
  -var="snapshot_id=uehara1028-before-renew-wizstg"
```

**2回目以降（通常運用）**:
```bash
terraform plan -var-file="terraform_${ENV}.tfvars" \
  -var="restore_from_snapshot=false"
terraform apply -var-file="terraform_${ENV}.tfvars" \
  -var="restore_from_snapshot=false"
```

---

## 5. GitHub Actions設定

**ワークフローファイル例** (`.github/workflows/${ENV}_push.yml`):
```yaml
AWS_REGION: ap-northeast-1
AWS_ACCOUNT_ID: 904271084068
AWS_ROLE_ARN: arn:aws:iam::904271084068:role/${APP_ID}-${ENV}-GitHubActionsOIDCRole
ECR_REPOSITORY: ecr-${APP_ID}-${ENV}-${REGION_SHORT}
ECS_CLUSTER_NAME: ${APP_ID}-${ENV}-${REGION_SHORT}-cluster
ECS_SERVICE_NAME: ${APP_ID}-${ENV}-${REGION_SHORT}-service
LATEST_TAG: ${ENV}-latest
```

---

## 6. 確認事項

### 6.1 作成されたリソース
- S3: State管理バケット × 2個
- ECR: `ecr-${APP_ID}-${ENV}-${REGION_SHORT}`
- ECS: クラスター・サービス
- RDS: スナップショットから復元されたDB

### 6.2 動作確認
1. GitHub Actionsでのイメージプッシュ
2. ECSでの自動デプロイ
3. アプリケーション動作確認

---

## 重要なポイント

1. **環境変数活用**: `ENV` を変更するだけで開発・本番を切替
2. **ECR分離**: 環境別に完全分離されたECR
3. **State分離**: Terraform Stateも環境別に管理
4. **スナップショット復元**: 初回のみ、2回目以降は通常運用
5. **Bootstrap廃止**: 手動S3作成でシンプル化

この手順により、再利用可能で安全なインフラ構築が実現できます。