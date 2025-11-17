import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    // { duration: '30s', target: 5 },
    // { duration: '1m', target: 20 },
    // { duration: '30s', target: 0 },
    { duration: '30s', target: 20 },    // 30秒で20ユーザー
    { duration: '1m', target: 100 },    // 1分で100ユーザー
    { duration: '2m', target: 150 },    // 1分で100ユーザー
    { duration: '30s', target: 0 },     // 30秒で0ユーザー
  ],
};

export default function () {
  const params = {
    headers: {
      'Authorization': 'Basic dHN1bmFndWphcGFuOnRzdW5hZ3UwOTA0',
    },
    timeout: '30s', 
  };

  const response = http.get('https://w-rails-dev-tokyo.sukejima.com/', params);

  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 10000ms': (r) => r.timings.duration < 10000,
    'basic auth works': (r) => r.status !== 401,
  });

  sleep(2);
}
