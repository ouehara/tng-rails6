class CouponsController < ApplicationController
    before_action :set_article, only: [:show]
    add_breadcrumb I18n.t('coupon_headline'), :coupons_path
    def index
        page = 1
        if(params.has_key?(:page))
            page = params[:page]
        end
        @coupons = Article.published_coupon(I18n.locale).page(page).per(30).order("(schedule->>'#{I18n.locale}')::timestamp desc")
    end
    def show
        @ad = SidebarAd.get_cached.to_json(:methods => [:banner_url])
        @article.get_i18n(I18n.locale)
        @adBanner = nil
        if @show_bar
            @article_editor = @article.article_editor.where(:lang => I18n.locale).order("updated_at desc").first
        end
        get_available_languages
        if (!@availLanguages[I18n.locale.to_s] && I18n.locale.to_s == "en" && current_user.nil? || (!current_user.nil? && User.roles[current_user.role] < User.roles[:tester]))
            raise ActiveRecord::RecordNotFound
            return
        end
        if (!@availLanguages.key?(I18n.locale.to_s) && I18n.locale.to_s != "en" && current_user.nil?)  || (!@availLanguages[I18n.locale.to_s] && I18n.locale.to_s != "en" && current_user.nil?)
            redirect_to show_coupons_path(I18n.default_locale ,@article), status: :moved_permanently
            return
        end

        #breadcrumb

        add_breadcrumb @article.disp_title[0]
        #seo
        articlePath =  show_coupons_path(@article)
        if(I18n.locale.to_s != "en")
            articlePath = show_coupons_path(I18n.locale, @article)
            #canon = article_path(I18n.locale,@article)
        end

        if(!@article.canonical.blank? && @article.canonical != "null")
            set_meta_tags canonical: @article.canonical
        end

        @title = @paginated ? +@article.disp_title[0] + " Page "+ params[:page] : @article.disp_title[0]
        @description = @paginated ? @article.excerpt[0] + " Page "+ params[:page] : @article.excerpt[0]
        @keywords = @article.all_tags() +","
        @keywords += @article.all_tag_groups()+"," unless @article.all_tag_groups.empty?
        @keywords += @article.cached_category.name unless @article.cached_category.nil?
        httpUri = URI.parse(@article.medium_url)
        httpUri.scheme = "http"
        set_meta_tags og: {
          title:    @title,
          type:     'article',
          url:       request.original_url,
          description: @description,
          image: [{
              _: httpUri.to_s,
              secure_url: @article.medium_url,
          }],
        }
        # set_meta_tags twitter: {
        #   card:  "summary_large_image",
        #   title: @title,
        #   description: @description,
        #   image: @article.medium_url
        # }
        if request.original_fullpath.split('?').first != articlePath
            return redirect_to articlePath, status: :moved_permanently
        end
        respond_to do |format|
            if @article.coupon?
                format.html {render file: 'coupons/show.html.erb'}
            else
                return redirect_to  show_articles_path(I18n.locale, @article), status: :moved_permanently
            end
        end
    end

    private
    def set_article
        if params[:id] == params[:id].to_i.to_s
          @article = Article.where(id: params[:id]).first
          redirect_to article_path(I18n.locale ,@article), status: :moved_permanently
        else
          @article = Article.find_cached(params[:id])
        end
    end
    def get_available_languages
    @availLanguages = {}
    @article.is_translated.each do |lang, status|
        if @article.is_translated[lang] == "publish"
        @availLanguages[lang] = lang
        end
        if @article.is_translated[lang] == "future" && @article.schedule[lang] < Time.now
        @availLanguages[lang] = lang
        end
    end
    end
end
