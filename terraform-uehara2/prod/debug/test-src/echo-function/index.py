import json
import base64
from datetime import datetime

def lambda_handler(event, context):
    """
    ALBから送信されたリクエストをそのままエコーして返却する
    すべてのヘッダーと詳細情報を表示
    """

    # すべてのヘッダーを統合（multiValueHeadersを優先）
    all_headers = {}

    # 通常のheadersから取得
    if event.get("headers"):
        all_headers.update(event["headers"])

    # multiValueHeadersがある場合は上書き（より詳細な情報）
    if event.get("multiValueHeaders"):
        for key, values in event["multiValueHeaders"].items():
            if values:
                # 複数値の場合はリストとして保存
                all_headers[key] = values if len(values) > 1 else values[0]

    # リクエスト内容を詳細に抽出
    echo_response = {
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "method": event.get("httpMethod", "UNKNOWN"),
        "path": event.get("path", ""),
        "headers": event.get("headers", {}),
        "multiValueHeaders": event.get("multiValueHeaders", {}),
        "allHeaders": all_headers,  # 統合されたすべてのヘッダー
        "headerCount": len(all_headers),
        "queryStringParameters": event.get("queryStringParameters", {}),
        "multiValueQueryStringParameters": event.get("multiValueQueryStringParameters", {}),
        "body": event.get("body", ""),
        "isBase64Encoded": event.get("isBase64Encoded", False),
        "requestContext": event.get("requestContext", {}),
        "rawEvent": event  # デバッグ用：生のイベント全体
    }

    # Base64エンコードされたボディをデコード
    if echo_response["isBase64Encoded"] and echo_response["body"]:
        try:
            decoded_body = base64.b64decode(echo_response["body"]).decode('utf-8')
            echo_response["decodedBody"] = decoded_body
        except Exception as e:
            echo_response["decodedBody"] = f"Failed to decode: {str(e)}"

    # レスポンス作成
    response = {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "X-Echo-Server": "ALB-Lambda-Echo",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type, X-Requested-With"
        },
        "body": json.dumps(echo_response, indent=2, ensure_ascii=False)
    }

    # CloudWatch Logsに詳細を記録
    print(f"Echo request: {echo_response['method']} {echo_response['path']}")
    print(f"Total headers received: {echo_response['headerCount']}")
    print(f"All headers: {json.dumps(all_headers, indent=2)}")

    return response