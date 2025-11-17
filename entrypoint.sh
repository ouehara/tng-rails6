#!/bin/bash
# Entry point for Rails (production-ready)
# - 依存関係は Docker ビルド時に完結（起動時の再インストールは禁止）
# - 本番運用を想定した、時刻付き・レベル付きの簡潔なログ出力
# - DB 接続待機、マイグレーション制御、CDN 置換は冪等
# - 失敗は即時終了（set -Eeuo pipefail）

set -Eeuo pipefail

###############################################################################
# Logging
###############################################################################
_ts() { date +"%Y-%m-%dT%H:%M:%S%z"; }
log_info()  { printf "%s [INFO]  %s\n" "$(_ts)" "$*"; }
log_warn()  { printf "%s [WARN]  %s\n" "$(_ts)" "$*"; }
log_error() { printf "%s [ERROR] %s\n" "$(_ts)" "$*" >&2; }
abort()     { log_error "$*"; exit 1; }

###############################################################################
# Environment sanity
###############################################################################
# 本番デフォルトで NODE_ENV/BABEL_ENV を production に揃える（未指定時のみ）
: "${RAILS_ENV:=production}"
if [[ "$RAILS_ENV" == "production" ]]; then
  : "${NODE_ENV:=production}"
  : "${BABEL_ENV:=production}"
fi

log_info "Booting Rails"
log_info "Ruby: $(ruby -v)"
log_info "Bundler: $(bundle -v)"
log_info "Env: RAILS_ENV=${RAILS_ENV} NODE_ENV=${NODE_ENV:-} BABEL_ENV=${BABEL_ENV:-}"

# SECRET_KEY_BASE は production では必須
if [[ -z "${SECRET_KEY_BASE:-}" && "$RAILS_ENV" == "production" ]]; then
  abort "SECRET_KEY_BASE is required in production"
fi

###############################################################################
# Bundler: 起動時の再インストールは禁止
# すべての gem は Docker ビルド時に固定。欠落していればイメージを再構築する。
###############################################################################
log_info "Checking bundled gems"
if ! bundle check >/dev/null 2>&1; then
  abort "Bundled gems missing. Rebuild the image (bundle install must run at build time)."
fi
log_info "Gems OK"

###############################################################################
# Database: 接続待機とマイグレーション
# - 接続文字列は DATABASE_URL を優先。無ければ RDS_* 環境変数から生成。
# - CREATE_DB_ON_BOOT=true の時のみ db:create を実行（本番は通常不要）。
# - SKIP_MIGRATION=true でマイグレーションを抑止。
###############################################################################
# 接続 URL の決定
PG_URL="${DATABASE_URL:-}"
if [[ -z "$PG_URL" && -n "${RDS_HOST_NAME:-}" && -n "${RDS_DB_NAME:-}" && -n "${RDS_USER_NAME:-}" ]]; then
  pass_part=""
  [[ -n "${RDS_DB_PASSWORD:-}" ]] && pass_part=":${RDS_DB_PASSWORD}"
  PG_URL="postgres://${RDS_USER_NAME}${pass_part}@${RDS_HOST_NAME}:5432/${RDS_DB_NAME}"
fi

# DB 待機（URL が得られた場合のみ）
if [[ -n "$PG_URL" ]]; then
  log_info "Waiting for PostgreSQL readiness"
  # postgresql-client（pg_isready）が web イメージに入っている前提
  until pg_isready -d "$PG_URL" -t 2 >/dev/null 2>&1; do sleep 1; done
  log_info "PostgreSQL is ready"
else
  log_warn "DATABASE_URL is not set (and no RDS_* fallback). Skipping DB readiness check."
fi

# 初回作成（明示フラグ時のみ）
if [[ "${CREATE_DB_ON_BOOT:-false}" == "true" ]]; then
  log_info "rails db:create"
  bundle exec rails db:create || log_info "db:create skipped or DB already exists"
fi

# マイグレーション（デフォルト実行）
if [[ "${SKIP_MIGRATION:-false}" != "true" ]]; then
  log_info "rails db:migrate"
  bundle exec rails db:migrate
else
  log_info "Skip migrations (SKIP_MIGRATION=true)"
fi

###############################################################################
# Assets: ビルド済みを使用（起動時ビルド禁止）
# - 存在チェックのみ行い、欠落していればイメージの問題として明示。
###############################################################################
manifest_warned=false

if [[ -f public/packs/manifest.json && -s public/packs/manifest.json ]]; then
  log_info "Webpacker manifest found: public/packs/manifest.json"
else
  log_warn "Webpacker manifest missing: public/packs/manifest.json"
  manifest_warned=true
fi

if compgen -G "public/assets/.sprockets-manifest-*.json" >/dev/null 2>&1; then
  log_info "Sprockets manifest found: public/assets/.sprockets-manifest-*.json"
else
  log_warn "Sprockets manifest missing: public/assets/.sprockets-manifest-*.json"
  manifest_warned=true
fi

if [[ "$manifest_warned" == "true" ]]; then
  log_warn "Precompiled assets not found. Ensure assets are compiled at image build time."
fi

###############################################################################
# CDN: 置換処理
# - production では CLOUDFRONT_DOMAIN を必須にして明示的に置換。
# - 非本番では未設定でも警告のみに留める。
###############################################################################
if [[ "$RAILS_ENV" == "production" && -z "${CLOUDFRONT_DOMAIN:-}" ]]; then
  abort "CLOUDFRONT_DOMAIN is required in production for CDN URLs"
fi

if [[ -n "${CLOUDFRONT_DOMAIN:-}" ]]; then
  log_info "Applying CDN domain: ${CLOUDFRONT_DOMAIN}"
  if [[ -d config/locales ]]; then
    # locales: ENV_CLOUDFRONT_DOMAIN -> 実ドメイン
    find config/locales -name "*.yml" -print0 | xargs -0 -r sed -i "s|ENV_CLOUDFRONT_DOMAIN|${CLOUDFRONT_DOMAIN}|g"
  fi
  # 静的 HTML の置換例
  if [[ -f public/wkp/wkp_tj.html ]]; then
    sed -i "s|ENV_CLOUDFRONT_DOMAIN_PLACEHOLDER|${CLOUDFRONT_DOMAIN}|g" public/wkp/wkp_tj.html
  fi
  log_info "CDN placeholders replaced"
else
  log_warn "CLOUDFRONT_DOMAIN not set (non-production or intentionally omitted)"
fi

###############################################################################
# Start application
###############################################################################
if [[ "${DEBUG_MODE:-false}" == "true" ]]; then
  log_warn "DEBUG_MODE=true; holding container for debugging (sleep)"
  tail -f /dev/null
else
  log_info "Starting: $*"
  exec "$@"
fi
