import http from 'k6/http';
import { check, sleep } from 'k6';

// ====== 設定ここから ======
const BASE_URL = 'https://w-rails-dev-tokyo.sukejima.com'; // ★変更したい場合はここ
const AUTH_HEADER = 'Basic dHN1bmFndWphcGFuOnRzdW5hZ3UwOTA0'; // Basic認証トークン
// ====== 設定ここまで ======

export const options = {
  stages: [
    // スケールアウト領域
    { duration: '1m', target: 50 },
    { duration: '2m', target: 100 },
    // { duration: '2m', target: 200 },

    // スケールイン領域
    { duration: '2m', target: 50 },
    { duration: '1m', target: 0 },
  ],

  thresholds: {
    http_req_duration: ['p(95)<2000'], // 95%のリクエストが2秒以内
    http_req_failed: ['rate<0.1'],     // エラー率10%未満
  },
};

export default function () {
  const params = {
    headers: {
      Authorization: AUTH_HEADER,
      'User-Agent': 'k6-load-test/1.0',
    },
  };

  // メインページへのアクセス
  const res = http.get(`${BASE_URL}/`, params);

  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 2000ms': (r) => r.timings.duration < 2000,
    'basic auth works': (r) => r.status !== 401,
    'page contains content': (r) => r.body && r.body.length > 1000,
  });

  // ランダム待機（1〜3秒）
  sleep(Math.random() * 2 + 1);
}

export function handleSummary(data) {
  return {
    'load-test-results.json': JSON.stringify(data, null, 2),
    stdout: `
========================================
K6 負荷テスト結果サマリー
========================================
平均処理時間: ${data.metrics.iteration_duration.values.avg.toFixed(2)}ms
総リクエスト数: ${data.metrics.http_reqs.values.count}
成功率: ${(100 * (1 - data.metrics.http_req_failed.values.rate)).toFixed(1)}%
95パーセンタイル: ${data.metrics.http_req_duration.values['p(95)'].toFixed(2)}ms

ECSオートスケール確認項目:
1. CloudWatchでCPUが target_value (例: 40〜50%) を超えたか
2. タスク数が段階的に増減（1→2→3→2→1）したか
3. スケールアウト/インのタイミングが期待どおりか
========================================
`,
  };
}
