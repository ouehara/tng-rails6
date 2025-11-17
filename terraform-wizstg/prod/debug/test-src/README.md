# Echo Server Lambda Function

## 概要
ALBから受信したHTTPリクエストの内容をそのままJSONで返却するエコーサーバー機能。

## 機能
- HTTPリクエストの全情報をJSONで返却
- Base64エンコードされたボディの自動デコード
- CORS対応
- CloudWatch Logsでのアクセスログ記録

## レスポンス例
```json
{
  "timestamp": "2025-09-28T04:00:00.000Z",
  "method": "POST",
  "path": "/echo",
  "headers": {
    "content-type": "application/json",
    "user-agent": "curl/7.68.0"
  },
  "body": "{\"test\": \"data\"}",
  "queryStringParameters": {
    "param1": "value1"
  },
  "requestContext": {
    "elb": {...},
    "sourceIp": "10.0.1.100"
  }
}
```

## デプロイ方法
1. Terraformでインフラをデプロイ
2. Lambda関数コードをZIPアーカイブとして作成
3. AWS Lambda コンソールまたはTerraformでデプロイ

## アクセス方法
```bash
# GET リクエスト
curl https://your-alb-domain.com/echo

# POST リクエスト
curl -X POST https://your-alb-domain.com/echo \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'
```

## 制限事項
- 一時利用目的のため、本番環境での長期利用は非推奨
- ALBのタイムアウト設定に依存
- リクエストサイズはALB・Lambdaの制限に従う