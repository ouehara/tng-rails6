class Admin::ArticlesController < Admin::ApplicationController
  include ArticleRules
  before_action :set_article, only: [:show, :edit, :update, :destroy,:duplicate]
  before_action :set_ransack_search_object

  # GET /admin/articles
  # GET /admin/articles.js
  # @param [String] order Order
  # @param [String] page Pagination
  def index
    @articles = @q.result(distinct: false).order('id desc').page(params[:page]).article
    @sort = "id"
    @asc = true
    @page = params[:page]
    @cat_filter = ""
    if params.has_key?(:tag)
      @articles = Article.tagged_with(params[:tag]).order('id desc').page(params[:page])
    end
    if params.has_key?(:cat_filter) && params[:cat_filter]  != "-1"
      @cat_filter = params[:cat_filter]
      @articles = Area.find(params[:cat_filter]).articles.page(params[:page])
    end
    if params.has_key?(:sort)
      sort_articles
      @sort = params[:sort]
      @asc = params[:asc]
    end

    if params.has_key?(:search)
      if params[:search] == params[:search].to_i.to_s
        article = Article.order('id desc').where(id: params[:search]).page(1)
        @articles = article
      end
      @articles = @articles.full_text_search(query: params[:search]) unless article
    end

    @lang = "en"
    if params.has_key?(:set_locale) && params[:set_locale]  != "all"
      @lang = params[:set_locale]
      @articles = @articles.select_translated(params[:set_locale])
    end
    if params.has_key?(:set_locale) && params[:set_locale]  == "all"
      @lang = "en"
      params[:set_locale] = ""
    end
    @areas = Area.roots.includes(:translations)
    respond_to do |format|
      format.html { render }
      format.js { render }
      if params.has_key?(:cat_filter) && params[:cat_filter]  != "-1"
        format.csv { send_data Article.as_csv(params[:cat_filter]) }
      end
    end
  end

  def landingpage_show
    @articles = @q.result(distinct: false).order('id desc').page(params[:page]).landingpage
    respond_to do |format|
      format.html  {render file: 'admin/articles/list.html.erb'}
      format.js { render }
    end
  end

  def coupon_show
    @articles = @q.result(distinct: false).order('id desc').page(params[:page]).coupon
    respond_to do |format|
      format.html  {render file: 'admin/articles/list.html.erb'}
      format.js { render }
    end
  end

  def otomo_show
    @articles = @q.result(distinct: false).order('id desc').page(params[:page]).otomo_tour
    respond_to do |format|
      format.html  {render file: 'admin/articles/list.html.erb'}
      format.js { render }
    end
  end

  def quick_edit
    if autorize_bulk_action
      @categories = Category.all.includes(:translations)
      @areas = Area.roots.includes(:translations)
      @grouping = ArticleGroup.get_sorted
    end
    @article = Article.find_by(id: params[:id])
    respond_to do |format|
        format.js
    end
  end

  def sort_articles
    asc = params[:asc] && params[:asc] == "true" ? "ASC" : "DESC"
    if params[:sort] == "status"
      @articles = @q.result(distinct: false).select("is_translated->>'en', *").order("
      CASE
        WHEN is_translated->>'en' = 'publish' THEN '1'
        WHEN is_translated->>'zh-hant' = 'publish' THEN '2'
        WHEN is_translated->>'zh-hans' = 'publish' THEN '3'
        WHEN is_translated->>'en' = 'draft' THEN '5'
        WHEN is_translated->>'zh-hant' = 'draft' THEN '6'
        WHEN is_translated->>'zh-hans' = 'draft' THEN '7'
      END #{asc}", id: :desc
      ).page(params[:page])

    end
    if params[:sort] == "date"
      @articles = @q.result(distinct: true).select("created_at, *").order("created_at #{asc}",id: :desc).page(params[:page])
    end
  end
  # GET /admin/articles/1
  # GET /admin/articles/1.json
  def show
  end

  # GET /admin/articles/new
  def new
    @article = Article.new
  end

  # GET /admin/articles/1/edit
  def edit
    autorize(@article)
  end

  def bulk_edit
    if !autorize_bulk_action
      return
    end
    @articles = params[:bulkAction].join(",")
    @categories = Category.all
    @areas = Area.roots
  end

  def import
    Article.importCSV( params[:article][:import_file] )
    redirect_to admin_articles_url
  end

  def bulk_save
    articles = Article.find article_params[:ids].split(",");
    updates = article_params.except(:ids)
    respond_to do |format|
      articles.each do |article|
        article.update(updates)
      end
      format.html { redirect_to admin_articles_url, notice: 'Article was successfully updated.' }
    end
  end

  def quick_save
    @articles = Article.find article_param[:id];
    updates = article_param.except(:id)
    group = ArticleGroup.find(params[:article_groups])
    respond_to do |format|
      @articles.update(updates) && @articles.article_groupings.create(:article_group => group)
      format.js
    end
  end

  def change_status
    @articles = Article.find params[:id];
    @articles.is_translated.each do |key, array|
      if key == params[:lang]
        @articles.is_translated[key] = params[:status]
      end
    end
    respond_to do |format|
      @articles.save
      format.js
    end
  end

  # POST /admin/articles
  # POST /admin/articles.json
  def create
    I18n.locale = article_params[:locale]

    @article = Article.new(article_params.except(:locale))
    respond_to do |format|
      if @article.save
        ArticleUser.c(current_user.id, @article.id)
        ArticleTranslator.c(current_user.id, @article.id)
        format.html { redirect_to edit_article_path(article_params[:locale],@article) }
        # format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        # format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/articles/1
  # PATCH/PUT /admin/articles/1.json
  def update
    autorize(@article)
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to [:admin, @article], notice: 'Article was successfully updated.' }
        # format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        # format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def duplicate
    if (!autorize(@article))
      return
    end
    duplicate = @article.amoeba_dup
    title = duplicate.title

    duplicate.slug = "new-copy #{Date.today.to_s}"

    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        hash = Digest::MD5.hexdigest("#{Date.today.to_s}#{Random.rand(1000)}")
        duplicate.slug =  @article.slug.nil? ? "new-copy-#{hash}-#{locale}" : "#{@article.slug}-new-copy-#{hash}-#{locale}"
        duplicate.title = duplicate.title.nil? ? "new-copy #{hash}" :  "#{@article.title}-new-copy-#{hash}"
      end
      duplicate.disp_title[locale] = @article.disp_title[locale.to_s] + " copy " unless @article.disp_title[locale.to_s].nil?
      duplicate.is_translated[locale] = "draft"
    end


    duplicate.save!
    respond_to do |format|
      format.html { redirect_to [:admin, duplicate], notice: 'Article was successfully cloned.' }
    end
  end
  # DELETE /admin/articles/1
  # DELETE /admin/articles/1.json
  def destroy
    if (!autorize(@article))
      return
    end
    @article.destroy
    respond_to do |format|
      format.html { redirect_to admin_articles_url, notice: 'Article was successfully destroyed.' }
      # format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def article_param
    params.permit(:id,:area_id,:category_id,:all_tags)
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:article).permit(:title, :contents, :ids,:area_id,:category_id,:all_tags,:locale)
  end

  # Set ransack search object
  def set_ransack_search_object
    @q = Article.ransack(params[:q])
  end
end
