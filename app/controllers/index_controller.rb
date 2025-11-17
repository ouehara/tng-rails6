class IndexController < ApplicationController
  include Conf
  #caches_page :index, :show
  def index
    @related = []
    Area.where("in_sidebar=true").each do |el|
        image = ''
        if el.depth	>= 2
          image = el.parent.slug
        end
        val = {"link" => I18n.locale== :en ? area_path(nil,el) : area_path(I18n.locale,el), "title"=>el.name,
            "image_url" => ActionController::Base.helpers.asset_pack_path("media/images/area/area_"+(image != "" ? image :  el.slug)+"M400.jpg") }
        @related << val
    end
    @related += @related
    @related += @related
    page = 1
    if(params.has_key?(:page))
      page = params[:page]
    end

    ogtitle = I18n.t("site_top.title_prefix")
    desc = I18n.t("site_top.page_desc")
    set_meta_tags title: ogtitle
    set_meta_tags description: desc
    set_meta_tags separator: "-"
    set_meta_tags reverse: false

    @newestArticle = []
    getNewestArticle
    @recommendedArea = getRecommendedArea
    @tags = getTags
    @tips = getTips
    @restaurant = getRestaurant
    padding = 5 - @promoids.length
    if padding < 0
      padding = 0
    end
    @hideBreadcrumb = true
    @newestArticle += Article.translation_published_simple(I18n.locale).order("(schedule->>'#{I18n.locale}')::timestamp desc, id desc").limit(padding).where.not(id: @promoids)
    @videos = Video.all.with_translations(I18n.locale).limit(3).order(:position)
    @articles = Article.includes(:translations, :users).
    translation_published_simple(I18n.locale)
    .page(page).per(9).order("(schedule->>'#{I18n.locale}')::timestamp desc, id desc")
    @newestArticle = @newestArticle.to_json(:methods => [:original_url, :cached_category, :cached_area, :get_path])
    @maxPage = @articles.total_pages
    if(@maxPage.to_i < page.to_i)
      raise ActionController::RoutingError.new('Not Found')
    end
    @paged = page != 1
    if !current_user.nil? && current_user.administrator?
      @sections = TopPageSection.all.order("top_page_sections.id").with_translations(I18n.locale)
    else
      @sections = TopPageSection.all.with_translations(I18n.locale).includes(:translations).order("top_page_sections.id").where(active: 1)
    end
    @topArticles = Article.translation_published_simple(I18n.locale).order("impressions_count").limit(6)
    #@coupons = Article.published_coupon(I18n.locale).limit(6)
    @ad = SidebarAd.get_cached.to_json(:methods => [:banner_url])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @articles.to_json(:methods => [:thumb_url, :cached_users, :prefecture]) }
    end
  end

  private

  def getNewestArticle
    promoArt = PromoArticle.includes(:article).where(lang: I18n.locale).order(:position)
    #if(browser.device.mobile?)
    #  promoArt = promoArt
    #end
    @promoids = []

    promoArt.each do |promo|
      @promoids << promo.articles_id
      if(@newestArticle.length <= 4)
        @newestArticle += Article.where(id: promo.articles_id).translation_published_simple(I18n.locale)
      end
    end
  end



end
