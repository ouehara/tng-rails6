# CDN設定クラス（CloudFront変更に耐えられるようにCDN設定クラスを新規作成　new create by miyagi20250803）
class CdnConfig
  class << self
    def cloudfront_domain
      @cloudfront_domain ||= ENV['CLOUDFRONT_DOMAIN']
    end

    def cloudfront_url(path = "")
      @cloudfront_base_url ||= "https://#{cloudfront_domain}"
      "#{@cloudfront_base_url}#{path}"
    end

    # 開発時のリロード対応
    def reload!
      @cloudfront_domain = nil
      @cloudfront_base_url = nil
    end
  end
end

# 開発環境でのリロード対応
if Rails.env.development?
  Rails.application.config.to_prepare do
    CdnConfig.reload!
  end
end