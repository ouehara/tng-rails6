# 【不具合課題】バッチタスクの重複実行問題

## 問題概要
ECSバッチタスクが重複実行され、同じバッチジョブが複数同時に動作している状況が発生。

## 発生している症状
1. **missing_images:check_articles**バッチが15時間以上実行中
2. 手動実行時に既存のバッチタスクと重複して起動
3. リソースの無駄遣いと処理の競合が発生

## 確認された事実
- タスクID `3cad2b68a807414ebb135257231d8265`: 2025-10-01 08:01開始（15時間以上実行中）
- タスクID `871437ed824f4011a41c9bae17d34a67`: 2025-10-01 23:32開始（手動実行）
- 両方とも`w-rails-0930-dev-apn1-batch-missing-images:1`で同じタスク定義
- 画像URLチェック処理で無限ループまたは極端に遅い処理が発生

## 影響範囲
- **missing_images:check_articles**バッチ（毎日8時JST実行）
- **xml:articles**バッチ（毎日7時JST実行）
- **sitemap:refresh**バッチ（毎日6時JST実行）

## 原因分析
### 根本原因
1. **重複実行防止機能なし**: EventBridgeが既存タスクの状態を確認せずに新規タスクを起動
2. **タイムアウト制御なし**: 長時間実行されるタスクを停止する仕組みがない
3. **処理性能問題**: missing_imagesバッチの画像URLチェック処理が異常に遅い

### 技術的詳細
- EventBridge → ECS RunTaskが直接実行される
- 既存タスクの実行状態チェック機能なし
- ECSタスク定義にタイムアウト設定なし

## 対策案

### 案1: DynamoDBロック方式（推奨）★採用予定
**概要**: アプリケーションレベルでの排他制御
- DynamoDBテーブルでロック管理
- TTL機能で自動的にロック解除
- Railsタスク開始時にロック取得、終了時に解放

**メリット**:
- 軽量でシンプル
- 既存のEventBridge構成をそのまま利用
- 確実な重複防止

**実装要素**:
```
- DynamoDBテーブル作成
- Railsアプリにロック機能追加
- 各バッチタスクにロック処理組み込み
- 環境変数でDynamoDBテーブル名設定
```

### 案2: Step Functions オーケストレーション
**概要**: EventBridge → Step Functions → ECS RunTask
- Step Functions側で並列実行制御
- リトライ・エラーハンドリング機能
- 実行状況の可視化

### 案3: ECSサービス化
**概要**: バッチを常駐タスクとして実行
- desired_count=0で通常停止
- 実行時のみdesired_count=1に変更
- 自然に重複防止される

### 案4: Lambda経由実行
**概要**: EventBridge → Lambda → ECS RunTask
- Lambda関数で実行中タスクチェック
- 重複時はスキップしてログ出力

## 緊急対応
1. **長時間実行タスクの停止検討**
   - 現在15時間以上実行中のタスクの停止判断
   - ログ確認により処理状況把握

2. **手動実行時の事前確認**
   ```bash
   aws ecs list-tasks --cluster w-rails-0930-dev-apn1-cluster \
     --family w-rails-0930-dev-apn1-batch-missing-images \
     --desired-status RUNNING
   ```

## 実装優先度
1. **高**: missing_imagesバッチの性能問題調査・修正
2. **高**: DynamoDBロック方式の実装
3. **中**: 他バッチへの同様対策適用
4. **低**: Step Functions化の検討

## 関連ファイル
- `terraform/dev/11-batch-ecs.tf` - バッチタスク定義
- `terraform/dev/17-batch-scheduler.tf` - EventBridgeスケジュール
- `lib/tasks/missing_images/missing_images.rake` - 問題のバッチ処理
- `lib/tasks/xml/articles.rake` - XMLバッチ処理
- `config/sitemap.rb` - サイトマップ更新処理

## 実施予定（案1: DynamoDBロック方式で実装）
- [ ] DynamoDBロックテーブル作成（Terraform）
- [ ] Railsアプリにロック機能実装（BatchLockクラス作成）
- [ ] バッチタスクの修正（各rakeタスクにロック処理組み込み）
- [ ] 動作テスト実施（重複実行防止の確認）
- [ ] 本番環境への適用

### 実装メモ
- **DynamoDBテーブル名**: `w-rails-0930-dev-apn1-batch-locks`
- **TTL設定**: デフォルト60分、処理時間に応じて調整
- **ロックキー**: バッチ名（missing_images_check, xml_articles, sitemap_refresh）
- **環境変数追加**: `BATCH_LOCK_TABLE`をECSタスク定義に追加