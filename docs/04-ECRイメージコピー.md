# ECRイメージコピー手順書（オプション）

## 概要

本番環境のECRイメージを新環境にコピーします。

| 対象 | 内容 | 時間 | コスト |
|------|------|------|------|
| Dockerイメージ | 本番環境のコンテナイメージ | 10-30分 | ローカル実行のためデータ転送料金発生 |

**実行場所**: ローカルマシン（Docker CLI + AWS CLI必須）

## 前提条件

1. Docker CLIがインストール済み
2. AWS CLIがインストール・設定済み
3. 本番ECRレジストリへのアクセス権限あり
4. 新環境ECRレジストリへのプッシュ権限あり

---

## 手順

### 1. 環境変数設定

```bash
# コピー元（Wiz-AWS）の設定
export SRC_ACCOUNT="904271084068"
export SRC_REGION="us-west-2"
export SRC_PROFILE="904271084068"
export SRC_REPOSITORY="ecr-z-rails-0927-uswest2"

# コピー先（新環境）の設定
export DEST_ACCOUNT="266735816071"
export DEST_REGION="ap-northeast-1"
export DEST_PROFILE="266735816071"
export DEST_REPOSITORY="ecr-x-rails-0928-apnortheast1"

# コピーするタグ
export IMAGE_TAG="dev-latest"

# 自動生成される値
export SRC_REGISTRY="${SRC_ACCOUNT}.dkr.ecr.${SRC_REGION}.amazonaws.com"
export DEST_REGISTRY="${DEST_ACCOUNT}.dkr.ecr.${DEST_REGION}.amazonaws.com"
```

### 2. コピー元からイメージをプル

```bash
# コピー元ECRにログイン & プル
aws ecr get-login-password --region $SRC_REGION --profile $SRC_PROFILE \
  | docker login --username AWS --password-stdin $SRC_REGISTRY

docker pull $SRC_REGISTRY/$SRC_REPOSITORY:$IMAGE_TAG
```

### 3. コピー先にイメージをプッシュ

```bash
# コピー先ECRにログイン
aws ecr get-login-password --region $DEST_REGION --profile $DEST_PROFILE \
  | docker login --username AWS --password-stdin $DEST_REGISTRY

# タグ付け & プッシュ
docker tag $SRC_REGISTRY/$SRC_REPOSITORY:$IMAGE_TAG \
           $DEST_REGISTRY/$DEST_REPOSITORY:$IMAGE_TAG

docker push $DEST_REGISTRY/$DEST_REPOSITORY:$IMAGE_TAG
```

### 4. 確認

```bash
# 新環境ECRでイメージを確認
aws ecr describe-images --repository-name $DEST_REPOSITORY \
  --region $DEST_REGION --profile $DEST_PROFILE
```

---

## 実行例

### 具体的なコマンド例
```bash
# コピー元（Wiz-AWS）にログイン & pull
aws ecr get-login-password --region us-west-2 --profile 904271084068 \
  | docker login --username AWS --password-stdin 904271084068.dkr.ecr.us-west-2.amazonaws.com

docker pull 904271084068.dkr.ecr.us-west-2.amazonaws.com/ecr-z-rails-0927-uswest2:dev-latest

# コピー先（俺の会社）にログイン & push
aws ecr get-login-password --region ap-northeast-1 --profile 266735816071 \
  | docker login --username AWS --password-stdin 266735816071.dkr.ecr.ap-northeast-1.amazonaws.com

# イメージ名でタグを付け直し
docker tag 904271084068.dkr.ecr.us-west-2.amazonaws.com/ecr-z-rails-0927-uswest2:dev-latest \
           266735816071.dkr.ecr.ap-northeast-1.amazonaws.com/ecr-x-rails-0928-apnortheast1:dev-latest

# プッシュ
docker push 266735816071.dkr.ecr.ap-northeast-1.amazonaws.com/ecr-x-rails-0928-apnortheast1:dev-latest
```

---

## 注意事項

### セキュリティ
- 本番環境のイメージには機密情報が含まれる可能性があります
- 適切なアクセス権限の管理を行ってください

### タグ管理
- 本番環境: `prod-latest`, `prod-v1.0.0` など
- 開発環境: `dev-latest`, `dev-v1.0.0` など
- タグの命名規則を統一してください

### 容量とコスト
- ローカル実行のためインターネット経由のデータ転送料金が発生
- ECRストレージ料金は発生します
- イメージサイズ約1.5GB想定で、データ転送料金は数ドル程度

---

## トラブルシューティング

### ログインエラーの場合
```bash
# AWSプロファイルを確認
aws sts get-caller-identity

# ECRレジストリのURLを確認
aws ecr describe-repositories --region ap-northeast-1
```

### プッシュ権限エラーの場合
- IAMユーザー/ロールにECRプッシュ権限があるか確認
- ECRリポジトリのリソースポリシーを確認

### イメージサイズが大きい場合
```bash
# 並行ダウンロード/アップロードの設定
export DOCKER_BUILDKIT=1
docker system prune -f  # 不要なイメージを削除
```