aws_region = "ap-northeast-1"
availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]# 利用するアベイラビリティゾーン利用するアベイラビリティゾーン
app_identifier = "x-rails-0928" # アプリケーション識別子
owner_tag = "shogo"
environment = "dev" # 環境設定 (dev, prod のみ許可)

# 開発者拠点IP制限（開発環境用）
developer_ip_whitelist = [
  {
    cidr_block  = "175.130.50.153/32"
    description = "wizgeek-office-m"
  },
  {
    cidr_block  = "106.72.159.1/32"
    description = "wizgeek-office-u"
  },
  {
    cidr_block  = "126.91.154.7/32"
    description = "wizgeek-office-m2"
  }
]

# S3バケットのIP制限設定
enable_s3_ip_restriction = true  # 開発環境ではIP制限を有効化

# ドメイン名設定（CloudFront用ACM証明書）
# ALB用は自動で "alb-" プレフィックスが付与される
domain_name = "xmiyagi-dev-tokyo.scrum-xxx.com"

# データベース認証情報
db_username = "postgres"
db_password = "password"  # 本番環境では適切なパスワードに変更してください
db_name = "mydatabasev2"

# Rails設定
rails_secret_key_base = "dummy_secret_key_for_development_do_not_use_in_production_12345678901234567890123456789012345678901234567890123456789012345678901234567890"

# メール設定
noreply_email = "noreply@yourapp.com"

# フォールバックCloudFront設定(現在のELB環境のCDNドメイン)
legacy_cloudfront_domain = "d20aeo683mqd6t.cloudfront.net"

# 初回作成時はDNS検証を省略したいので false にして applyしてください
use_custom_domain = true