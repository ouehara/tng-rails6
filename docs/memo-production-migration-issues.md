# 本番移行課題・改善事項

## 📊 対応状況サマリー

| 優先度 | 課題 | 状況 | 対応日 |
|--------|------|------|--------|
| ✅ Critical | RDS暗号化・バックアップ | **対応完了** | 2024-09-27 |
| ✅ High | IAM権限最小化 | **対応完了** | 2024-09-27 |
| ✅ High | ALBセキュリティグループ制限 | **対応完了** | 2024-09-27 |
| 🚨 Critical | **ECS環境変数設定** | **本番リリース前必須** | - |
| 🚨 Critical | **AWS CloudSearch未構築** | **本番リリース前必須** | - |
| ⚠️ Critical | 機密情報管理 | **PM判断で後回し** | - |
| 📋 High | S3セキュリティ | **運用判断でスキップ** | - |
| 📋 Medium | WAFレート制限 | **優先度低で未対応** | - |
| 📋 Medium | 監査ログ・VPC Flow Logs | **未対応** | - |
| 📋 Medium | ElastiCache暗号化 | **未対応** | - |
| 📋 Medium | ElastiCache Memcachedスケール対応 | **本番・新環境共通課題** | - |
| 📋 High | **ECSオートスケーリング戦略** | **性能テスト後策定必要** | - |
| 📋 High | **CloudFrontキャッシュ戦略最適化** | **本番負荷に基づく調整必要** | - |
| 📋 Medium | S3 CORS設定の本番対応 | **本番移行時検討** | - |
| 📋 Medium | IAMユーザー→ECSタスクロール移行 | **セキュリティ強化** | - |
| 📋 Low | コンテナセキュリティ | **未対応** | - |

---

## 📊 本番環境との差分一覧

### リソースバージョン・スペック比較

| リソース | 項目 | 本番環境 | 新環境（dev） | 影響・備考 |
|----------|------|----------|---------------|------------|
| **ElastiCache Memcached** | インスタンスタイプ | `cache.r5.large` | `cache.t3.micro` | メモリ：13.07GB → 0.5GB |
| | エンジンバージョン | `1.4.34` | `1.6.22` | セキュリティ・機能向上 |
| | パラメータグループ | `default.memcached1.4` | カスタム（memcached1.6） | 設定の細かな差異あり |
| | ノード数 | `1` | `1` | **両環境ともスケール設定なし** |
| | スケール設定 | **なし** | **なし** | 将来のトラフィック増加時に要対応 |
| **RDS PostgreSQL** | インスタンスタイプ | `db.t3.xlarge` | `db.t3.micro` | vCPU: 4→2, RAM: 16GB→1GB |
| | エンジンバージョン | `13.20` | `13.20` | **同一バージョン** ✅ |
| | ストレージタイプ | `汎用 SSD (gp2)` | `汎用 SSD (gp2)` | **同一タイプ** ✅ |
| | ストレージ容量 | `40 GiB` | `40 GiB` | **同一容量** ✅ |
| | 暗号化 | `有効でない` | `有効` | **新環境がセキュア** ✅ |
| | マルチAZ | `なし` | `なし` | **両環境とも単一AZ** ⚠️ |
| | 削除保護 | `有効` | `有効` | **両環境とも有効** ✅ |
| | Performance Insights | `無効` | `無効` | **両環境とも無効** |
| | 拡張モニタリング | `無効` | `無効` | **両環境とも無効** |
| | パラメータグループ | `custom-postgres13` | `default.postgres13` | **要調査：本番のカスタム設定内容不明** ⚠️ |
| | 自動バックアップ | `有効 (3日)` | `有効 (3日)` | **同一保持期間** ✅ |
| | バックアップウィンドウ | `13:15-13:45 UTC` | `13:15-13:45 UTC` | **同一時間帯** ✅ |
| | 自動マイナーバージョンアップグレード | `有効` | `有効` | **両環境とも自動更新** ✅ |
| | メンテナンスウィンドウ | `木曜 01:20-01:50 JST` | `木曜 01:20-01:50 JST` | **同一設定** ✅ |
| **ECS** | Fargateプラットフォーム | 要確認 | `LATEST` | - |
| | CPUメモリ設定 | 要確認 | 要確認 | - |
| **ALB** | タイプ | 要確認 | Application Load Balancer | - |
| | SSL/TLS設定 | 要確認 | TLSv1.2_2021 | - |
| **CloudFront** | 価格クラス | 要確認 | `PriceClass_100` | - |
| | HTTPバージョン | 要確認 | `http2` | - |
| **WAF** | ルール設定 | 要確認 | カスタムルール | - |
| | レート制限 | 要確認 | 基本設定のみ | - |

### 💡 差分調査が必要な項目

以下の本番環境情報を調査して上記表を完成させる必要があります：

1. **RDS PostgreSQL カスタムパラメータグループ** ⚠️ **本番環境調査必要**
   - **本番の `custom-postgres13` パラメータグループの設定値が不明**
   - 以下のコマンドで本番設定を確認する必要あり：
     ```bash
     # 本番環境のパラメータグループ詳細取得
     export AWS_PROFILE=production-profile
     aws rds describe-db-parameters \
       --db-parameter-group-name custom-postgres13 \
       --region ap-northeast-1 \
       --output json > prod-pg-params.json
     ```
   - 主要な確認項目：
     - max_connections
     - shared_buffers
     - work_mem
     - effective_cache_size
     - ログ設定（log_statement, log_min_duration_statement）
     - autovacuum設定
     - checkpoint設定

2. **ECS**
   - Fargateプラットフォームバージョン
   - タスク定義のCPU・メモリ設定
   - コンテナイメージバージョン

3. **CloudFront**
   - 現在の価格クラス設定
   - キャッシュポリシー設定
   - オリジン設定

4. **その他**
   - S3バケット設定
   - IAMロール・ポリシー
   - VPCネットワーク設定

### 📝 調査方法
```bash
# 本番環境情報取得コマンド例
export AWS_PROFILE=production-profile

# ElastiCache情報
aws elasticache describe-cache-clusters --cache-cluster-id tng-prod

# RDS情報
aws rds describe-db-instances

# ECS情報
aws ecs describe-services --cluster production-cluster

# CloudFront情報
aws cloudfront list-distributions
```

---

## 🚨 Critical Issues（重要）

### 1. ECS環境変数の設定 【本番リリース時必須】
**問題:**
- ECSタスク定義で9つの重要な認証情報がプレースホルダーのまま
- アプリケーションの基本機能（メール送信、SNS認証、検索）が動作しない

**未設定の環境変数 (`10-compute-ecs.tf`)**:
```hcl
# SMTP認証情報（メール送信機能用）
TNG_SENDER_USERNAME    = "your_smtp_username"
TNG_SENDER_PASSWORD    = "your_smtp_password"
TNG_SENDER_DOMAIN      = "your_smtp_domain"

# SNS認証情報（ソーシャルログイン用）
TNG_FACEBOOK_APP_ID    = "your_facebook_app_id"
TNG_FACEBOOK_APP_SECRET = "your_facebook_app_secret"
TNG_TWITTER_CONSUMER_KEY    = "your_twitter_consumer_key"
TNG_TWITTER_CONSUMER_SECRET = "your_twitter_consumer_secret"

# CloudSearch認証情報（検索機能用）
TNG_CLOUD_SEARCH_ENDPOINT_DOCUMENT = "your_cloudsearch_document_endpoint"
TNG_CLOUD_SEARCH_ENDPOINT_SEARCH   = "your_cloudsearch_search_endpoint"
TNG_CLOUD_SEARCH_REGION            = var.aws_region  # 設定済み
```

**影響:**
- メール送信機能が利用不可
- Facebook/Twitterログインが利用不可
- 記事検索機能が利用不可（CloudSearch）
- アプリケーションの主要機能が制限される

**対応方法:**
1. **本番環境用の認証情報取得**
   - SMTP: AWS SES または外部メールサービスの設定
   - Facebook: Meta Developer登録・アプリ作成
   - Twitter: X Developer登録・API取得
   - CloudSearch: 既存本番CloudSearchエンドポイントの確認

2. **terraform_dev.tfvarsまたは環境変数で設定**
3. **セキュリティ**: AWS Secrets Managerの使用を推奨

**対応タイミング:** **本番リリース前必須**

### 1-2. AWS CloudSearchの未構築 【Critical】
**問題:**
- RailsアプリでAWS CloudSearchを使用しているが、Terraformで未定義
- 記事検索機能が利用できない状態

**使用箇所** (`app/models/article.rb`):
```ruby
# ドキュメント管理用
Aws::CloudSearchDomain::Client.new({
  endpoint: ENV['TNG_CLOUD_SEARCH_ENDPOINT_DOCUMENT']
})

# 検索用
Aws::CloudSearchDomain::Client.new({
  endpoint: ENV['TNG_CLOUD_SEARCH_ENDPOINT_SEARCH']
})
```

**未設定項目:**
1. **Terraformリソース**: CloudSearchドメインが未定義
2. **ECS環境変数**: 以下3つが未設定
   ```bash
   TNG_CLOUD_SEARCH_ENDPOINT_DOCUMENT
   TNG_CLOUD_SEARCH_ENDPOINT_SEARCH
   TNG_CLOUD_SEARCH_REGION
   ```

**影響:**
- **記事検索機能が完全に動作不可**
- **Railsアプリケーションのコア機能が利用不能**

**対応方法:**
1. TerraformでCloudSearchドメイン作成
2. ECSタスク定義に環境変数追加
3. 検索インデックスの初期構築

**対応タイミング:** **本番リリース前必須**

### 2. 機密情報管理 【PM判断：後回し】
**問題:**
- データベースパスワード平文保存（`variables.tf`）
- Rails秘密鍵ハードコード
- AWS認証情報がECSタスク定義に埋め込み

**リスク:**
- 認証情報の漏洩
- 不正アクセス
- 監査・コンプライアンス違反

**推奨対応:**
```terraform
# AWS Secrets Manager導入
resource "aws_secretsmanager_secret" "database_credentials" {
  name = "${local.app_identifier}-${local.environment}-database-credentials"
}

# ECSタスクでSecrets Manager参照
secrets = [
  {
    name      = "DB_PASSWORD"
    valueFrom = aws_secretsmanager_secret.database_credentials.arn
  }
]
```

**対応タイミング:** 本番運用前必須

---

## ✅ 対応完了項目

### 1. RDS暗号化・バックアップ強化 【完了】
**実施内容:**
- `storage_encrypted = true` - データ暗号化有効
- `skip_final_snapshot = false` - 最終スナップショット保護
- `publicly_accessible = false` - パブリックアクセス明示的無効
- `auto_minor_version_upgrade = false` - 自動バージョンアップ無効

### 2. IAM権限最小化 【完了】
**実施内容:**
- `CloudWatchLogsFullAccess` → 専用ログ群のみアクセス
- `AmazonSSMFullAccess` → ECS Exec専用権限のみ

**修正前（危険）:**
```terraform
policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
```

**修正後（安全）:**
```terraform
# 最小権限ポリシー作成
resource "aws_iam_policy" "ecs_cloudwatch_logs_limited" {
  policy = jsonencode({
    Statement = [{
      Action = ["logs:CreateLogStream", "logs:PutLogEvents"]
      Resource = "${aws_cloudwatch_log_group.ecs_task_logs.arn}:*"
    }]
  })
}
```

### 3. ALBセキュリティグループ制限 【完了】
**実施内容:**
- プライベートサブネット内リソースからのアクセス許可
- CloudFront VPC Origin からのアクセス許可
- 外部インターネットからの直接アクセス制限

**アクセス可能:**
- ✅ プライベートサブネット内EC2（踏み台）
- ✅ ECSタスク
- ✅ CloudFront VPC Origin
- ❌ 外部インターネット（直接）

---

## 📋 未対応項目（優先度別）

### High Priority

#### 1. S3セキュリティ強化 【運用判断でスキップ】
**現状:** CORS設定でワイルドカード（`*`）許可
**判断:** 静的ファイル配信のため制限不要
**代替対策:** パブリックアクセスブロック・CloudFront OAC で十分

#### 2. CloudFront WAF強化 【優先度低】
**未実装機能:**
- レート制限（DDoS対策）
- AWS Managed Rules（OWASP対策）
- カスタムブロックルール

**推奨設定例:**
```terraform
# レート制限: 2000req/5分
rule {
  name = "RateLimitRule"
  statement {
    rate_based_statement {
      limit = 2000
      aggregate_key_type = "IP"
    }
  }
  action { block {} }
}
```

### Medium Priority

#### 3. 監査・ログ強化
**未実装:**
- VPC Flow Logs
- CloudTrail詳細ログ
- セキュリティイベント監視

**推奨実装:**
```terraform
resource "aws_flow_log" "vpc_flow_log" {
  traffic_type = "ALL"
  vpc_id      = aws_vpc.vpc.id
}
```

#### 4. ElastiCache暗号化
**現状:** 暗号化なし
**推奨:**
```terraform
resource "aws_elasticache_cluster" "memcached" {
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
}
```

#### 5. ElastiCache Memcachedスケール対応 【本番・新環境共通課題】
**問題:**
- **本番環境・新環境ともに単一ノード構成**（`num_cache_nodes = 1`）
- **本番環境にもスケール設定が存在しない**
- 将来的なスケール時にRailsアプリケーションコードの修正が必要
- 現在のRails設定は単一エンドポイントのみ対応

**現在の設定:**
```ruby
# production.rb
config.cache_store = :mem_cache_store, "#{ENV['MEMCACHED_ENDPOINT']}:#{ENV['MEMCACHED_PORT']}"
```

**スケール時の必要対応:**
1. **Terraform側**: `num_cache_nodes` を増加（2-3ノード推奨）
2. **Rails側**: マルチノード対応のキャッシュストア設定
3. **インフラ側**: 各ノードエンドポイントの環境変数管理

**推奨実装:**
```ruby
# マルチノード対応版
memcached_servers = []
(0...ENV['MEMCACHED_NODE_COUNT'].to_i).each do |i|
  memcached_servers << "#{ENV["MEMCACHED_NODE_#{i}_ENDPOINT"]}:#{ENV['MEMCACHED_PORT']}"
end

config.cache_store = :mem_cache_store, memcached_servers,
  {
    :expires_in => 1.day,
    :compress => true,
    :pool_size => 30,
    :namespace => 'tng-ruby',
    :failover => true,
    :socket_timeout => 1.5,
    :socket_failure_delay => 0.2
  }
```

**対応タイミング:** 本番トラフィック増加時・パフォーマンス改善時

#### 6. 静的アセットS3バケットのCORS設定 【本番移行時検討】
**対象バケット**: `static_assets` バケット（CSS/JS/画像等の静的ファイル用）

**問題:**
- **静的アセット用S3バケット**で全オリジンからのアクセスを許可
- **任意のWebサイトから静的アセットへのアクセスが可能**
- **CSRF攻撃のリスク**：悪意のあるサイトからファイルアップロード可能
- **帯域幅の悪用**：他サイトからの画像・CSS直リンク
- **セキュリティ監査で指摘される可能性**

**現在の設定** (`07-storage-s3.tf:162`):
```hcl
# 静的アセットバケットのCORS設定
resource "aws_s3_bucket_cors_configuration" "static_assets_cors" {
  bucket = aws_s3_bucket.static_assets.id
  cors_rule {
    allowed_origins = ["*"]  # 全オリジン許可
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
  }
}
```

**推奨対応:**
```hcl
# 本番環境では実際のドメインに制限
allowed_origins = [
  "https://${var.domain_name}",
  "https://www.${var.domain_name}"
]
```

**対応タイミング:** 本番移行時にドメイン制限を実施

#### 7. IAMユーザーからECSタスクロールへの移行 【セキュリティ強化】
**問題:**
- **長期間有効な認証情報（Access Key）をアプリケーションで使用**
- **認証情報の漏洩リスク**：ログ出力、環境変数、コード埋め込み等
- **手動でのローテーション**：認証情報の更新が手動で煩雑
- **過剰な権限付与リスク**：IAMユーザーに不要な権限が付与される可能性
- **セキュリティインシデント時の影響範囲拡大**
- **AWS Well-Architected Framework違反**

**現在の設定** (`07-storage-s3.tf:273`):
```hcl
# TODO: セキュリティ向上のためECSタスクロールへの移行を検討
resource "aws_iam_user" "s3_static_assets_user" {
  name = "..."
}
```

**推奨対応:**
1. ECSタスクロールにS3アクセス権限を付与
2. アプリケーションをIAMロール使用に変更
3. 既存IAMユーザーを削除

**メリット:**
- 認証情報の管理が不要
- 一時的な認証情報の自動ローテーション
- より高いセキュリティレベル

**対応タイミング:** セキュリティ強化実施時

### High Priority（追加）

#### 8. ECSオートスケーリング戦略 【性能テスト後策定必要】
**現状:**
- **ECSタスク数固定**: `desired_count = 1`（単一タスク）
- **オートスケーリング未設定**
- **負荷に応じた自動拡張不可**

**必要な対応:**
1. **性能テスト実施**
   - 現在のタスクスペック（1 vCPU、2GB メモリ）での限界値測定
   - 同時接続数・リクエスト/秒の閾値確認
   - レスポンスタイム劣化ポイントの特定

2. **スケーリングポリシー策定**
   ```hcl
   # 推奨: CPU使用率ベースのオートスケーリング
   resource "aws_appautoscaling_target" "ecs_target" {
     min_capacity       = 1
     max_capacity       = 10  # 性能テスト結果から決定
     resource_id        = "service/${aws_ecs_cluster.app_cluster.name}/${aws_ecs_service.rails_app_service.name}"
     scalable_dimension = "ecs:service:DesiredCount"
   }
   
   # CPU使用率70%でスケールアウト
   resource "aws_appautoscaling_policy" "cpu_scaling" {
     target_tracking_scaling_policy_configuration {
       target_value       = 70.0
       scale_in_cooldown  = 300  # 5分
       scale_out_cooldown = 60   # 1分
       predefined_metric_specification {
         predefined_metric_type = "ECSServiceAverageCPUUtilization"
       }
     }
   }
   ```

3. **メトリクス候補**
   - CPU使用率（推奨: 70-80%）
   - メモリ使用率
   - ALBのTargetResponseTime（推奨: 1秒以下）
   - ALBのActiveConnectionCount

**対応タイミング:** 本番移行前の性能テスト時

#### 9. CloudFrontキャッシュ戦略最適化 【本番負荷に基づく調整必要】
**現状の問題:**
- **画一的なキャッシュTTL設定**
- **本番の実際のアクセスパターンが未考慮**
- **キャッシュヒット率が不明**

**現在の設定（14-cdn-distribution.tf）:**
```hcl
# デフォルト（HTMLページ）: キャッシュなし (TTL=0)
# 静的アセット: 1年 (TTL=31536000)
# 画像ファイル: 1日 (TTL=86400)
# フィード: 1時間 (TTL=3600)
```

**必要な対応:**
1. **本番環境のアクセスパターン分析**
   - CloudFrontログ解析
   - キャッシュヒット率測定
   - 人気コンテンツの特定
3. **キャッシュ無効化戦略**
   - 記事更新時の自動invalidation
   - デプロイ時のキャッシュクリア自動化
4. **測定指標**
   - **Cache Hit Ratio**: 目標80%以上
   - **Origin Latency**: CloudFrontからオリジンへの遅延
   - **Viewer Response Time**: エンドユーザーのレスポンス時間

**推奨ツール:**
- AWS CloudWatch Insights（ログ分析）
- CloudFront Reports（キャッシュ統計）
- X-Ray（トレーシング）

**対応タイミング:** 本番移行後1-2週間のデータ収集後

### Low Priority

#### 10. コンテナセキュリティ
**改善項目:**
- ECRイメージスキャン有効化
- ECSタスク非rootユーザー実行

---

## 📚 参考資料

### AWS セキュリティベストプラクティス
- [AWS Security Best Practices](https://aws.amazon.com/architecture/security-identity-compliance/)
- [Terraform Security Best Practices](https://developer.hashicorp.com/terraform/cloud-docs/policy-enforcement/policy-sets/security)
