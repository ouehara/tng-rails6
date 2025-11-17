module OAuth
  module OAuthAdapter
    class Base
      attr_reader :provider, :uid, :name, :nickname, :email, :url, :image_url,
      :description, :other, :credentials, :raw_info
    end

    class Facebook < OAuthAdapter::Base

      # @param [Hash] auth env["omniauth.auth"]
      def initialize(auth)
        @provider    = auth["provider"]
        @uid         = auth["uid"]
        @name        = auth["info"]["name"]
        @nickname    = ""
        @email       = ""
        @url         = "https://www.facebook.com/"
        @image_url   = auth["info"]["image"]
        @description = ""
        @credentials = auth["credentials"].to_json
        @raw_info    = auth["extra"]["raw_info"].to_json
        freeze
      end
    end
  end
end
