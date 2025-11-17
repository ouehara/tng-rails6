

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :set_update_article, only: [:update, :destroy, :showjson]
  #caches_page :show
  include ArticleRules
 # before_filter :authenticate_user!
  before_action :authenticate_user!, :except => [:index, :show, :articleRelatedjson,:related_csv]
  # GET /articles
  # GET /articles.json
  def index
    page = 1
    d = 1.day.ago
    if(params.has_key?(:page))
      page = params[:page]
    end
    if(params.has_key?(:d))
      d =  Date.parse(params[:d]).strftime("%Y-%m-%d")
    end
      @title = t('article.title',param:params[:area])
      @desc = t('article.desc')
      langCodes = {"en"=> "en-US", "zh-hans"=> "zh-CN","zh-hant"=> "zh-TW",
      "th"=> "th-TH", "ko"=> "ko-KR", "vi"=> "vi-VN", "ja"=> "ja-JP", "id"=> "id-ID"}
      @language = langCodes[I18n.locale.to_s]
      @rss = Article.translation_published_timed(I18n.locale,d).find_in_batches(batch_size: 100)
      respond_to do |format|
        format.html # show.html.erb
        format.rss { render file: 'rss/feed', :layout => false }
        format.csv {send_data  Article.translation_published_timed(I18n.locale,d).to_csv}

      end
  end

  def related_csv
    @article = Article.where(id: params[:id]).first
    @article.get_i18n(I18n.locale)
    self.related_articles
    respond_to do |format|
      format.csv { send_data tb, filename: "related-#{@article.id}.csv" }
    end
  end

  def tb
    attributes = %w{id disp_title lang url related_id, related_title}
    csv_string = CSV.generate(headers: true) do |csv|
      csv << attributes
      @related_articles.each do |r|
        attri = [@article.id, @article.disp_title,
        I18n.locale, @article.get_url, r.id, r.disp_title]
        csv << attri
      end
    end
    csv_string

  end
  def showjson
    @article = Article.where(id: params[:id]).first
    if @article.nil?
      return
    end
    respond_to do |format|
      get_available_languages
      #if @availLanguages.count == 0
      #  format.json {render json: {}}
      #end
      format.html # show.html.erb
      format.json { render json: @article.to_json(:methods => [:cached_users])  }
    end
  end

  def articleRelatedjson
    respond_to do |format|
      #get_available_languages
      #if @availLanguages.count == 0
        #format.json {render json: {}}
      #end
      @article = Article.where(id: params[:id]).first
      if @article.nil?
        return
      end
      @article.get_i18n(I18n.locale)

      format.html # show.html.erb
      format.json { render json: @article.to_json(:methods => [:medium_url]) }
    end
  end
  # GET /articles/1
  # GET /articles/1.json
  def show
    if @article.nil?
      raise ActionController::RoutingError.new('Not Found')
    end
    if !@article.area.nil?
      self.related_articles
    end

    if @article.coupon?
      redirect_to show_coupons_path(I18n.locale ,@article), status: :moved_permanently
      return
    end
    if @article.otomo_tour?
      redirect_to otomo_path(I18n.locale, @article), status: :moved_permanently
      return
    end
    @endRelated = !DateTime.parse("2019-11-27 17:00:00").past?
    @things = Article.get_cached_articles_for_cat(2).to_json(only: [:schedule, :disp_title, :excerpt, :slug],:methods => [:thumb_url, :cached_users])
    @hotels = Article.get_cached_articles_for_cat(3).to_json(only: [:schedule, :disp_title, :excerpt, :slug],:methods => [:thumb_url, :cached_users])
    @shopping = Article.get_cached_articles_for_cat(4).to_json(only: [:schedule, :disp_title, :excerpt, :slug],:methods => [:thumb_url, :cached_users])
    @ad = SidebarAd.get_cached.to_json(:methods => [:banner_url])
    @related_articles = @related_articles.to_json(only: [:schedule, :disp_title, :excerpt, :slug], :methods => [:thumb_url, :cached_area])
    @page = params.has_key?(:page) ?  params[:page] : 1
    @paginated = params.has_key?(:page) && (true if Integer(params[:page]) rescue false)

    @article.get_i18n(I18n.locale)
    @adBanner = nil
    @adBanner = {
        "url" => traveling_safely_in_japan_path(I18n.locale == :en ? nil : I18n.locale) ,
        "image" =>  "media/images/covid/banner/#{(browser.device.mobile? ? 'art_bot/':'')}#{I18n.locale.to_s}.jpg",
        "id" => "tour-banner-article-top"
      }

    if @show_bar
      @article_editor = @article.article_editor.where(:lang => I18n.locale).order("updated_at desc").first
    end

    get_available_languages
    if (!@availLanguages[I18n.locale.to_s] && I18n.locale.to_s == "en" && current_user.nil? || (!current_user.nil? && User.roles[current_user.role] < User.roles[:tester]))
      raise ActiveRecord::RecordNotFound
      return
    end
    if (!@availLanguages.key?(I18n.locale.to_s) && I18n.locale.to_s != "en" && current_user.nil?)  || (!@availLanguages[I18n.locale.to_s] && I18n.locale.to_s != "en" && current_user.nil?)

        raise ActiveRecord::RecordNotFound
        return

      redirect_to article_path(I18n.default_locale ,@article), status: :moved_permanently
      return
    end

    @children = []
    category_siblings = @article.category.has_children? ? @article.category.child_ids : @article.category.sibling_ids
    Category.find(category_siblings).each do |el|
      c = Article
      .translation_published_simple(I18n.locale).where(category_id: el.id).length
      if c > 0
        val = {"link" => I18n.locale== :en ? category_path(nil,el) : category_path(I18n.locale,el), "title"=>el.name,}
        @children << val
      end
    end

    if @article.cached_category == nil
      add_breadcrumb "Articles", "/"
    else
      @article.cached_category.path.map do |a|
        add_breadcrumb a.name, categoryListing_path(a)
      end
    end
    add_breadcrumb @article.disp_title[0]
    articlePath = @paginated ? article_path(@article,params[:page]) : article_path(@article)
    #canon = article_path(@article)
    if(I18n.locale.to_s != "en")
      articlePath = @paginated ? show_articles_path( I18n.locale.to_s, @article.slug, params[:page], :format => nil) : article_path(I18n.locale,@article)
    #  canon = article_path(I18n.locale,@article)
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

    ## wow japan
    @wowjapan = false
    @article.cached_tags.each do |tag|
      if tag.name == "W.JAPAN"
        @wowjapan = true
      end
    end

    if request.original_fullpath.split('?').first != articlePath
      return redirect_to articlePath, status: :moved_permanently
    else
      imp = ImpressionsAdapter.new
      imp.add I18n.locale, 'article', @article.id
      respond_to do |format|
        if @article.landingpage?
          format.html {render file: 'landingpage/show.html.erb'}
        elsif @article.coupon?
          format.html {render file: 'coupons/show.html.erb'}
        elsif @article.otomo_tour?
          format.html {render file: 'otomo/show.html.erb'}
        else
          format.html
        end
        format.json { render json: @article }
      end
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
  # GET /articles/new
  def new
    autorize_new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
    @article = Article.friendly.find(params[:id])
    #@tag = Tag.order("id").all.includes(:translations)
    @category = Category.all.includes(:translations).all.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s
  }.sort {|x,y| x.ancestry <=> y.ancestry
  }
    puts @category.inspect
    @tag_groups = TagGroup.all.order(:position).includes(:translations)
    related =  @article.related_articles
    @pickups = {}
    related.each do |r|
      @pickups[r.related_article_id] = r.related_article
    end
    if editArt = ArticleEditor.is_editing(@article.id)
      if editArt.users_id != current_user.id && editArt.is_locked && !params.has_key?(:force)
        redirect_to [:admin, :dashboard], :alert => "#{editArt.user.username} is currently editing this article"
        return false
      else
        editArt.destroy
        articleEditor = ArticleEditor.new
        articleEditor.article = @article
        articleEditor.user = current_user
        articleEditor.lang = I18n.locale
        articleEditor.save
      end
    else
      articleEditor = ArticleEditor.new
      articleEditor.article = @article
      articleEditor.user = current_user
      articleEditor.lang = I18n.locale
      articleEditor.save
    end

    autorize(@article)
    #@area = Area.all.includes(:translations)
    @area = Area.includes(:translations).order(:pos ,:names_depth_cache)
  end

  # POST /articles
  # POST /articles.json
  def create
    autorize_new
    @article = Article.new(article_params)
    @article.user = current_user
    respond_to do |format|
      if @article.save
        format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    @article = Article.find(params[:id])
    if(params.has_key?(:draft))
      self.set_article_draft
      I18n.locale = params[:draft]
    else
      self.set_article_translated
      I18n.locale = params[:publish]
    end

    respond_to do |format|
      if params[:slug] == "null"
        params[:slug] = ""
      end
      @article.flush_cache
      if(!params.has_key?(:slug))
        if I18n.locale == :en && @article.is_translated[I18n.locale.to_s] != "publish"
          @article.title = ActiveSupport::JSON.decode(params[:disp_title])["en"]
        end
      else
        @article.title = params[:slug]
      end

      @article.setAuthor(params[:author])
      if(params.has_key?(:translator))
        @article.setTranslator(params[:translator])
      else
        @article.setTranslator(params[:author])
      end
      @article.publish
      @article.setContent(ActiveSupport::JSON.decode(params[:contents])[I18n.locale.to_s])
      @article.setSchedule(ActiveSupport::JSON.decode(params[:schedule])[I18n.locale.to_s])
      @article.setExcerpt(ActiveSupport::JSON.decode(params[:excerpt])[I18n.locale.to_s])
      @article.setDispTitle(ActiveSupport::JSON.decode(params[:disp_title])[I18n.locale.to_s])
      #if(params.has_key?(:copy_from))
      #  orig = I18n.locale
      #  I18n.locale = params[:copy_from]
      #  img = @article.title_image.url

      #  I18n.locale = orig
       # @article.title_image = img
      #end
      if(params.has_key?(:isPromotional))
        PromoArticle.
        update_or_create_by(
          {lang: I18n.locale.to_s, position: PromoArticle.positions[params[:isPromotional]]},
          {articles_id: @article.id, position: params[:isPromotional]}
        )
      end
      begin
        if @article.update(article_params)
          if(params.has_key?(:article_groups))
            group = ArticleGroup.where(id: params[:article_groups].split(/,/))
            @article.article_groupings.delete_all
            group.each do |g|
              @article.article_groupings.create(:article_group => g)
            end

          end

          #format.html { redirect_to @article, notice: 'Article was successfully updated.' }
          format.json { render :show, status: :ok, location: @article }
        else
          format.html { render :edit }#
          format.json { render json: @article.errors.full_messages.to_sentence, status: :unprocessable_entity }
        end
      rescue ActiveRecord::RecordInvalid => exception
        format.json { render json: exception.message, status: :unprocessable_entity }
      end

    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    autorize(@article)
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_article_translated
    translations = ActiveSupport::JSON.decode(params[:contents])
    translated = @article.is_translated
    schedule = @article.schedule
    if schedule.nil?
      schedule = {}
    end
    translations.each do |key, array|
      if key == params[:publish]
        translated[key] = "publish"
        if @article.is_translated[key] != "publish"
          schedule[key] = Time.now
        else
          schedule[key] = @article.schedule.nil? ? Time.now : @article.schedule[key]
          if schedule[key] == nil
            schedule[key] = Time.now
          end
        end
      end
    end
    @article.schedule = schedule
    @article.is_translated = translated
  end

  def set_article_draft
    translations = ActiveSupport::JSON.decode(params[:contents])
    translated = @article.is_translated
    translations.each do |key, array|
      if key == params[:draft]
        translated[key] = "draft"
      end
    end
    @article.is_translated = translated
  end

  def related_articles
    #Tag.includes(:translations).find(@article.tag_ids)
    if @article.nil?
      return
    end
    related =  @article.related_articles
    limit = 12 - related.length
    rel = related.pluck(:related_article_id)
    areaid =  @article.area_id
    @picked_up_article = Article
    .translation_published(I18n.locale).where("id IN (?)",rel)
    @related_articles = Article
    .translation_published(I18n.locale)
    .joins(:tag_group_to_articles)
    .where("articles.category_id = ?",@article.category_id)
    .where("articles.area_id = ?",areaid)
    .where('articles.id != ?', @article.id)
    @related_articles = @related_articles.where(tag_group_to_articles: { tag_group_id: @article.tag_group_ids }).group("articles.id").limit(limit).order("count(articles.id) desc, articles.id desc")

    limit = limit - @related_articles.length unless @related_articles.empty?
    if limit > 0 && @article.area.has_siblings?
      #area siblings and tag group category
      areaids = @article.area.sibling_ids
      ids = [@article.id] + @related_articles.map(&:id)
      @related_articles += Article
      .translation_published(I18n.locale)
      .joins(:tag_group_to_articles)
      .where.not(articles: {id: ids}).where("articles.category_id = ?",@article.category_id)
      .where(tag_group_to_articles: { tag_group_id: @article.tag_group_ids }).group("articles.id")
      .where(articles: {area_id: areaids}).limit(limit) if limit > 0
    end

    limit = limit - @related_articles.length unless @related_articles.empty?
    if limit > 0 && @article.area.has_siblings?
      #area siblings and category
      areaids = @article.area.sibling_ids
      ids = [@article.id] + @related_articles.map(&:id)
      @related_articles += Article
      .translation_published(I18n.locale)
      .where.not(articles: {id: ids}).where("articles.category_id = ?",@article.category_id)
      .where(articles: {area_id: areaids}).limit(limit) if limit > 0
    end

    limit = limit - @related_articles.length unless @related_articles.empty?
    if limit > 0
      #area top and tag group category
      areaid = @article.area.is_root? ? @article.area.id : @article.area.parent.id
      ids = [@article.id] + @related_articles.map(&:id)
      @related_articles += Article
      .translation_published(I18n.locale)
      .joins(:tag_group_to_articles)
      .where.not(articles: {id: ids}).where("articles.category_id = ?",@article.category_id)
      .where(tag_group_to_articles: { tag_group_id: @article.tag_group_ids })
      .where("articles.area_id = ?",areaid).limit(limit) if limit > 0
    end

    limit = limit - @related_articles.length unless @related_articles.empty?
    if limit > 0
      #area top and category
      areaid = @article.area.is_root? ? @article.area.id : @article.area.parent.id
      ids = [@article.id] + @related_articles.map(&:id)
      @related_articles += Article
      .translation_published(I18n.locale)
      .where.not(articles: {id: ids}).where("articles.category_id = ?",@article.category_id)
      .where("articles.area_id = ?",areaid).limit(limit) if limit > 0
    end

    limit = limit - @related_articles.length unless @related_articles.empty?
    if limit > 0
      #category and tag group
      ids = [@article.id] + @related_articles.map(&:id)
      @related_articles += Article
      .translation_published(I18n.locale)
      .where.not(articles: {id: ids}).where("articles.category_id = ?",@article.category_id).where("articles.area_id=?",@article.area_id).limit(limit) if limit > 0
    end

    limit = limit - @related_articles.length unless @related_articles.empty?
    if limit > 0
      # area and tags
      ids = [@article.id] + @related_articles.map(&:id)
      @related_articles += Article
      .translation_published(I18n.locale)
      .joins(:taggings)
      .where.not(articles: {id: ids})
      .where("articles.area_id = ?",areaid).where(taggings: { tag_id: @article.tag_ids }).group("articles.id").limit(limit).order("count(articles.id) desc, articles.id desc")
    end

    limit = limit - @related_articles.length unless @related_articles.empty?
    if limit > 0
      #area
      ids = [@article.id] + @related_articles.map(&:id)
      @related_articles += Article
      .translation_published(I18n.locale)
      .where.not(articles: {id: ids}).where("articles.area_id=?",@article.area_id).limit(limit) if limit > 0
    end

    limit = limit - @related_articles.length unless @related_articles.empty?
    if limit > 0
      #area
      ids = [@article.id] + @related_articles.map(&:id)
      @related_articles += Article
      .translation_published(I18n.locale)
      .where.not(articles: {id: ids}).where("articles.category_id=?",@article.category_id).limit(limit) if limit > 0
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_article
      if params[:id] == params[:id].to_i.to_s
        @article = Article.where(id: params[:id]).first
        if(@article.slug.nil? || @article.slug == "")
          raise ActiveRecord::RecordNotFound
        end
        redirect_to article_path(I18n.locale ,@article), status: :moved_permanently
      else
        @article = Article.find_cached(params[:id])
      end
    end

    def set_update_article
      if params[:id] == params[:id].to_i.to_s
        @article = Article.where(id: params[:id]).first
      else
        @article = Article.find_cached(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.permit(  :all_tags, :category_id, :title_image, :area_id, :sponsored_content, :lock_version, :all_related, :all_tag_groups, :canonical, :unlist, :template)
    end

    def render_csv
      set_file_headers
      set_streaming_headers

      response.status = 200

      #setting the body to an enumerator, rails will iterate this enumerator
      self.response_body = csv_lines()
    end


    def set_file_headers
      file_name = "transactions.csv"
      headers["Content-Type"] = "text/csv"
      headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
    end


    def set_streaming_headers
      #nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
      headers['X-Accel-Buffering'] = 'no'

      headers["Cache-Control"] ||= "no-cache"
      headers.delete("Content-Length")
    end

    def csv_lines
      Enumerator.new do |y|
        @rss.each do | a |
            y << a.to_csv.to_s
        end
      end
    end
end
