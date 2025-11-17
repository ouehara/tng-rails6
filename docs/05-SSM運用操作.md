# SSM踏み台サーバー運用マニュアル

## 概要

SSM Session Managerを利用してプライベートサブネット内のEC2インスタンスにセキュアにアクセスし、RDSデータベースやALBへの内部接続を行うためのマニュアルです。

## 前提条件

- AWS CLIがインストール済み
- 適切なAWSプロファイルが設定済み（266735816071）
- Session Manager Pluginがインストール済み
- terraform/dev/debugのリソースがデプロイ済み

---

## 1. SSM Session Managerでの接続

### EC2インスタンスIDの取得（動的）
```bash
# terraform outputから取得
cd terraform/dev/debug
export INSTANCE_ID=$(terraform output -raw ec2_instance_id)
echo $INSTANCE_ID
```

### SSMセッション開始
```bash
# 動的に取得したIDで接続
aws ssm start-session --target $INSTANCE_ID --region ap-northeast-1

# またはワンライナー
aws ssm start-session \
  --target $(cd terraform/dev/debug && terraform output -raw ec2_instance_id) \
  --region ap-northeast-1
```

### 接続確認
```bash
# EC2インスタンス内で実行
whoami  # ssm-user と表示される
cat /home/ec2-user/README.md  # 設定情報を確認
```

---

## 2. RDSデータベースへの接続

### 接続情報の確認
```bash
# EC2インスタンス内で実行
# RDSエンドポイント: x-rails-0928-dev-apn1-db-v2.cjoe2qekugsn.ap-northeast-1.rds.amazonaws.com
# データベース名: mydatabasev2
# ユーザー名: postgres
# パスワード: terraform_dev.tfvarsで設定した値
```

### PostgreSQL接続テスト
```bash
# RDSエンドポイントを動的に取得
export DB_HOST=$(cd /path/to/terraform/dev && terraform output -raw rds_endpoint)
export DB_USER="postgres"
export DB_NAME="mydatabasev2"
export DB_PASSWORD="password"  # 実際のパスワードに置き換え

# 接続テスト
PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "SELECT version();"

# インタラクティブモードで接続
PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME"
```

### よく使うPostgreSQLコマンド
```sql
-- テーブル一覧表示
\dt

-- データベース一覧
\l

-- 現在のデータベース情報
\conninfo

-- テーブル構造確認
\d テーブル名

-- 終了
\q
```

---

## 3. 内部ALBへのアクセス

### ALBエンドポイント確認
```bash
# 内部ALB DNS名: internal-x-rails-0928-dev-apn1-alb-1802883865.ap-northeast-1.elb.amazonaws.com
```

### curlでのアクセステスト
```bash
# EC2インスタンス内から実行

# ヘルスチェックエンドポイント
curl -v http://internal-x-rails-0928-dev-apn1-alb-1802883865.ap-northeast-1.elb.amazonaws.com/health

# HTTPSでのアクセス（証明書検証をスキップ）
curl -k -v https://alb-xmiyagi-dev-tokyo.sukejima.com/health

# レスポンスヘッダー確認
curl -I http://internal-x-rails-0928-dev-apn1-alb-1802883865.ap-northeast-1.elb.amazonaws.com/

# 特定のパス
curl http://internal-x-rails-0928-dev-apn1-alb-1802883865.ap-northeast-1.elb.amazonaws.com/echo

# タイムアウトやリトライ設定付き
curl --connect-timeout 5 --max-time 10 --retry 3 \
  http://internal-x-rails-0928-dev-apn1-alb-1802883865.ap-northeast-1.elb.amazonaws.com/health
```

### wgetでのアクセス
```bash
# ファイルダウンロード
wget http://internal-x-rails-0928-dev-apn1-alb-1802883865.ap-northeast-1.elb.amazonaws.com/robots.txt

# ヘッダー情報表示
wget -S --spider http://internal-x-rails-0928-dev-apn1-alb-1802883865.ap-northeast-1.elb.amazonaws.com/
```

---

## 4. トラブルシューティング

### SSM接続できない場合

1. **インスタンスの状態確認**
```bash
aws ec2 describe-instances --instance-ids i-098bd9b398604007e \
  --region ap-northeast-1 --query 'Reservations[0].Instances[0].State.Name'
```

2. **SSMエージェントの状態確認**
```bash
aws ssm describe-instance-information --region ap-northeast-1 \
  --filters "Key=InstanceIds,Values=i-098bd9b398604007e"
```

3. **インスタンス再起動**
```bash
aws ec2 reboot-instances --instance-ids i-098bd9b398604007e --region ap-northeast-1
```

### RDS接続できない場合

1. **セキュリティグループ確認**
```bash
# EC2のセキュリティグループがRDSへの5432ポートアクセスを許可しているか確認
aws ec2 describe-security-groups --group-ids sg-00cff56d312f90c1f \
  --region ap-northeast-1 --query 'SecurityGroups[0].IpPermissionsEgress'
```

2. **ネットワーク接続テスト**
```bash
# EC2内から実行
nc -zv x-rails-0928-dev-apn1-db-v2.cjoe2qekugsn.ap-northeast-1.rds.amazonaws.com 5432
```

### ALBアクセスできない場合

1. **ECSサービス状態確認**
```bash
aws ecs describe-services --cluster x-rails-0928-dev-apn1-cluster \
  --services x-rails-0928-dev-apn1-service --region ap-northeast-1 \
  --query 'services[0].{Status:status,RunningCount:runningCount,DesiredCount:desiredCount}'
```

2. **ターゲットグループのヘルス確認**
```bash
# ターゲットグループARNを取得してヘルス状態確認
aws elbv2 describe-target-health \
  --target-group-arn arn:aws:elasticloadbalancing:ap-northeast-1:266735816071:targetgroup/x-rails-0928-dev-apn1-tg/xxxxx \
  --region ap-northeast-1
```

---

## 5. SSMポートフォワーディングでRDSにGUIツールから接続

ローカルPCのGUIツール（DBeaver、TablePlus、pgAdmin等）からRDSに安全に接続できます。

### 前提条件
- AWS CLI v2インストール済み
- Session Manager プラグインインストール済み
```bash
# プラグイン確認
session-manager-plugin --version
```

### ポートフォワーディング設定

#### 方法1: RDSへの直接ポートフォワード（動的取得版）
```bash
# RDSエンドポイントを動的に取得
export RDS_ENDPOINT=$(cd terraform/dev && terraform output -raw rds_endpoint)
echo "RDS Endpoint: $RDS_ENDPOINT"

# EC2インスタンスIDを取得
export INSTANCE_ID=$(cd terraform/dev/debug && terraform output -raw ec2_instance_id)
echo "EC2 Instance: $INSTANCE_ID"

# RDSエンドポイントへ直接転送
aws ssm start-session \
  --target $INSTANCE_ID \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"$RDS_ENDPOINT\"],\"portNumber\":[\"5432\"],\"localPortNumber\":[\"15432\"]}" \
  --region ap-northeast-1
```

#### 方法1（ワンライナー版）
```bash
# すべてを1行で実行
aws ssm start-session \
  --target $(cd terraform/dev/debug && terraform output -raw ec2_instance_id) \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"$(cd terraform/dev && terraform output -raw rds_endpoint)\"],\"portNumber\":[\"5432\"],\"localPortNumber\":[\"15432\"]}" \
  --region ap-northeast-1
```

#### 方法2: EC2経由のローカルポートフォワード（代替方法）
```bash
# EC2のポートをローカルに転送
aws ssm start-session \
  --target i-098bd9b398604007e \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["5432"],"localPortNumber":["15432"]}' \
  --region ap-northeast-1
```

### GUIツール設定

セッション開始後、お好みのGUIツールで以下の設定で接続：

| 設定項目 | 値 |
|----------|-----|
| **ホスト** | `127.0.0.1` または `localhost` |
| **ポート** | `15432` |
| **データベース** | `mydatabasev2` |
| **ユーザー名** | `postgres` |
| **パスワード** | terraform_dev.tfvarsで設定した値 |
| **SSL** | 不要（プライベート接続のため） |

### 推奨GUIツール

1. **DBeaver** (無料・オープンソース)
   - https://dbeaver.io/
   - 多数のDB対応、日本語対応

2. **TablePlus** (有料・一部無料)
   - https://tableplus.com/
   - 軽量・高速、Mac/Windows/Linux対応

3. **pgAdmin** (無料・PostgreSQL専用)
   - https://www.pgadmin.org/
   - PostgreSQL公式管理ツール

4. **DataGrip** (有料・JetBrains製)
   - https://www.jetbrains.com/datagrip/
   - 高機能IDE、複数DB対応

### 接続例（pgAdmin）

1. **SSMポートフォワーディング開始**（ターミナルで実行）
   ```bash
   # 環境変数設定
   export RDS_ENDPOINT=$(cd terraform/dev && terraform output -raw rds_endpoint)
   export INSTANCE_ID=$(cd terraform/dev/debug && terraform output -raw ec2_instance_id)

   # ポートフォワーディング開始
   aws ssm start-session \
     --target $INSTANCE_ID \
     --document-name AWS-StartPortForwardingSessionToRemoteHost \
     --parameters "{\"host\":[\"$RDS_ENDPOINT\"],\"portNumber\":[\"5432\"],\"localPortNumber\":[\"15432\"]}" \
     --region ap-northeast-1
   ```

2. **pgAdminでサーバー追加**
   - 左パネル `Servers` 右クリック → `Register` → `Server...`

3. **設定タブ**
   - **General タブ**:
     - Name: `RDS via SSM (Staging)`
   - **Connection タブ**:
     - Host name/address: `127.0.0.1`
     - Port: `15432`
     - Maintenance database: `mydatabasev2`
     - Username: `postgres`
     - Password: `password`
   - **SSL タブ**:
     - SSL mode: `Prefer` または `Disable`

4. **Save** → 接続成功

### 接続例（DBeaver）

1. 新規接続作成 → PostgreSQL選択
2. 接続設定：
   - Server Host: `127.0.0.1`
   - Port: `15432`
   - Database: `mydatabasev2`
   - Username: `postgres`
   - Password: （設定値）
3. Test Connection → 成功確認
4. Finish

### トラブルシューティング

#### ポートフォワーディングが開始できない場合
```bash
# Session Managerプラグイン再インストール
# Mac
brew install --cask session-manager-plugin

# Windows (PowerShell管理者権限)
https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
```

#### 接続がタイムアウトする場合
```bash
# セッション状態確認
aws ssm describe-sessions --state Active --region ap-northeast-1

# EC2インスタンスの状態確認
aws ec2 describe-instances --instance-ids i-098bd9b398604007e \
  --region ap-northeast-1 --query 'Reservations[0].Instances[0].State.Name'
```

#### 別のポートを使いたい場合
```bash
# 例：ローカルポート5433を使用
export RDS_ENDPOINT=$(cd terraform/dev && terraform output -raw rds_endpoint)
export INSTANCE_ID=$(cd terraform/dev/debug && terraform output -raw ec2_instance_id)

aws ssm start-session \
  --target $INSTANCE_ID \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"$RDS_ENDPOINT\"],\"portNumber\":[\"5432\"],\"localPortNumber\":[\"5433\"]}" \
  --region ap-northeast-1
```

### セッション終了
- ターミナルで `Ctrl+C` または `exit`
- GUIツールの接続を先に切断してからセッション終了推奨

### メリット
- **セキュア**: 直接RDSを公開する必要なし
- **監査**: SSMセッション履歴がCloudTrailに記録
- **簡単**: VPNやBastion Host不要
- **無料**: SSM利用料は無料（EC2料金のみ）

---

## 6. セキュリティ注意事項

- SSMセッション履歴はCloudTrailに記録されます
- プロダクションデータへのアクセスは最小限に
- 作業完了後は必ずセッションを終了
- パスワードはコマンド履歴に残さないよう環境変数を使用

---

## 6. セッション終了

```bash
# EC2インスタンス内で
exit

# または Ctrl+D
```

---

## 7. リソースのクリーンアップ（作業完了後）

デバッグ用リソースは使用後削除することを推奨：

```bash
cd terraform/dev/debug
terraform destroy -var-file="../terraform_dev.tfvars"
```

---

## 付録: よく使うコマンドまとめ

```bash
# 環境変数設定（プロジェクトルートで実行）
export INSTANCE_ID=$(cd terraform/dev/debug && terraform output -raw ec2_instance_id)
export RDS_ENDPOINT=$(cd terraform/dev && terraform output -raw rds_endpoint)
export ALB_DNS=$(cd terraform/dev && terraform output -raw alb_dns_name)

# SSM接続
aws ssm start-session --target $INSTANCE_ID --region ap-northeast-1

# RDS接続（SSMセッション内で実行）
PGPASSWORD="password" psql -h $RDS_ENDPOINT -U postgres -d mydatabasev2

# SSMポートフォワーディング（ローカルから実行）
aws ssm start-session \
  --target $INSTANCE_ID \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"$RDS_ENDPOINT\"],\"portNumber\":[\"5432\"],\"localPortNumber\":[\"15432\"]}" \
  --region ap-northeast-1

# ALBヘルスチェック（SSMセッション内で実行）
curl https://$ALB_DNS/health

# ログ確認
tail -f /var/log/user-data.log  # 起動時のログ
```