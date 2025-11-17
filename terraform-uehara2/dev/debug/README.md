# デバッグ・DB操作用リソース管理

このディレクトリはデバッグ・DB操作用リソースを管理します。

## 使用方法

### 1. 初期化
```bash
cd debug/
terraform init
```

### 2. デバッグ用リソースの作成
```bash
terraform apply -var-file=../terraform_dev.tfvars
```

### 3. DB復旧作業実行
詳細は `../docs/terraformによる環境構築手順.md` を参照

### 4. 作業完了後のクリーンアップ
```bash
terraform destroy -var-file=../terraform_dev.tfvars
```

## 注意事項

- このディレクトリのリソースはデバッグ用です
- 作業完了後は削除してください
- メインのTerraform管理からは独立しています

## 含まれるリソース

- EC2インスタンス (デバッグ・DB操作用)
- 一時S3バケット (バックアップファイル保存用)
- STS VPCエンドポイント (AWS CLI認証用)
- IAMロール・ポリシー
- セキュリティグループ

## リファクタリング履歴

- 2025-09-27: メインTerraformから分離、temp→debugに名称変更
- 理由: デバッグ用途と本番インフラの分離