module ApplicationHelper

  # Rewrite Rails Standard flash to bootstrap classes
  # @param [String] flash_type Rails flash type, "notice", "warning", "error"など
  # @return [String] bootstrap class name
  # @see http://getbootstrap.com/components/#alerts
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  # Render html with concat using Bootstrap
  # @param [Hash] opts not using now
  # @return [nil]
  # @see http://getbootstrap.com/components/#alerts
  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "flash-messages alert #{bootstrap_class_for(msg_type)} fade in") do
              concat content_tag(:button, 'x', class: "close", aria: {label: "Close"}, data: { dismiss: 'alert' })
              concat message
            end)
    end
    nil
  end

  def body_class(class_name="top")
    content_for :body_class, class_name
  end

  def alternate_locales
    I18n.available_locales.map{|l|
      # if l.to_s != "ja"  && l != I18n.locale
      if l != I18n.locale
        yield(l)
      end
    }.join.html_safe
  end

  def link_to_add_fields(name, f, association)


    new_object = Tour::Buttons.new({btn: '', link: ''})

    id = new_object.object_id

    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def default_meta_tags
    {
      site: I18n.t("site_name"),
      reverse: true,
      separator: '|',
      robots: 'max-image-preview:large',
      fb: default_fb,
      og: defalut_og,
      twitter: default_twitter_card
    }
  end

  private

  def default_fb
    {
      app_id: '1451304635138108'
    }
  end

  def defalut_og
    {
      site_name: :site,
      title: :full_title,
      description: :description,
      type: 'website',
      url: request.original_url,
      image: ActionController::Base.helpers.asset_pack_path("media/images/og-tJ.png", host: "https://#{ENV['CLOUDFRONT_DOMAIN']}")
    }
  end

  def default_twitter_card
    twuser = ''
    if I18n.locale.to_s == "th"
      twuser = '@TsunagujapanTH'
    else
      twuser = '@tsunagu_Japan'
    end

    {
      card: 'summary_large_image',
      site: twuser
    }
  end

  # エディター機能が必要なページかどうかを判定
  # @return [Boolean] エディターページの場合true
  def editor_page?
    (controller.controller_name == "article_version") ||
    (controller.controller_name == "articles" && controller.action_name == "edit")
  end

  # 適切なJavaScriptパック名を取得
  # @return [String] JavaScriptパック名
  def javascript_pack_name
    editor_page? ? 'editor' : 'application'
  end

  # JavaScript読み込み用の共通オプション
  # @return [Hash] JavaScriptオプション
  def javascript_pack_options
    { 'data-turbolinks-track': 'reload', defer: true }
  end

  # CloudFront URLを動的に生成（性能最適化済み）
  # @param [String] path CloudFrontのパス
  # @return [String] 完全なCloudFront URL
  def cloudfront_url(path = "")
    @cloudfront_base_url ||= "https://#{ENV['CLOUDFRONT_DOMAIN']}"
    "#{@cloudfront_base_url}#{path}"
  end

  # localeの画像URLを新CDNに変換
  # @param [String] locale_key localeファイルのキー
  # @return [String] 新CDN URL
  def cloudfront_image_url(locale_key)
    image_url = t(locale_key)
    if image_url.include?('cloudfront.net')
      image_url.gsub(/https:\/\/[^.]+\.cloudfront\.net/, cloudfront_url)
    else
      image_url
    end
  end

end
