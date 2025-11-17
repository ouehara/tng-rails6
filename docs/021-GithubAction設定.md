## 3.GithubAction設定（任意）

### 概要
GithubActionのワークフロー定義ファイルの変数定義を修正してください。

- ソース: .github/workflows/dev_push.yml

### 特記事項
- Github側のセキュリティ設定を変更する必要はありません。必要な対応は
  - Githubワークフローファイルの修正('dev_push.yml')
  - terraform/common.main.tfに記載している。Githubのレポジトリ設定のみです。

### 設定箇所
以下の設定を、実際に作成したリソース名に変更してください（以下は設定例です）
```yaml
AWS_REGION: us-west-2                    # 使用するAWSリージョン
AWS_ACCOUNT_ID: 904271084068              # 利用するAWSアカウントID
AWS_ROLE_ARN: arn:aws:iam::904271084068:role/GitHubActionsOIDCRole  # 作成されたIAMロールのARN
ECR_REPOSITORY: ecr-v-rails6-uswest2      # 作成されたECRリポジトリ名
ECS_CLUSTER_NAME: v-rails6-dev-uswest2-cluster   # 作成されたECSクラスター名
ECS_SERVICE_NAME: v-rails6-dev-uswest2-service   # 作成されたECSサービス名
S3_ASSETS_BUCKET: v-rails6-dev-uswest2-static-assets-4bjjnnho  # 作成されたS3バケット名
LATEST_TAG: dev-latest                   # 使用するイメージタグ
```

## 動作確認

### GithubAction
**前提条件**: dev環境のリソース（特にS3バケット）が作成済みであることを確認してください。GitHubActionsがS3にアセットをアップロードするため、terraform/devでのリソース作成完了後に実行することを推奨します。

1. ワークフローファイルをGitHubにpushします：
```bash
git add .github/workflows/dev_push.yml
git commit -m "Update GitHub Actions workflow configuration"
git push origin main  # または対象ブランチ
```

2. GitHubリポジトリの「Actions」タブでワークフローの実行を確認します
3. ワークフローが正常に完了したら、AWSコンソールのECRでイメージが格納されることを確認してください
4. S3バケットにアセットファイルがアップロードされていることも確認してください
