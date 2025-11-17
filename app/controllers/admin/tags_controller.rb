class Admin::TagsController < Admin::ApplicationController
  include MissingImagesConcern
  before_action :set_lang, only: [:edit, :update]
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /admin/tags
  # GET /admin/tags.json
  # @param [String] order Order
  # @param [String] page Pagenation
  def index
    @tag = Tag.new
    @tags = Tag.page(params[:page])
    @tags = @tags.order(params[:order]) if params[:order]
    @missingTags = Tag.joins("inner join tag_translations on tags.id = tag_id").group("tags.id").having("count(tags.id) < 4")
    respond_to do |format|
      format.html
      format.csv { send_data Tag.as_csv }
    end
  end

  # GET /admin/tags/1
  # GET /admin/tags/1.json
  def show
  end

  # GET /admin/tags/new
  def new
    @tag = Tag.new
  end

  # GET /admin/tags/1/edit
  def edit
    @categories = Category.all.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s 
                  }.sort {|x,y| x.ancestry <=> y.ancestry 
                  }.map{ |c| ["-" * (c.depth - 1) + c.name,c.id] 
                  }.unshift(["-- none --", nil])
  end

  def import
    Tag.importCSV( params[:tag][:import_file] ) 
    redirect_to admin_tags_url
  end
  # POST /admin/tags
  # POST /admin/tags.json
  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to [:admin, @tag], notice: 'Tag was successfully created.' }
        # format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        # format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /merge
  def merge_view
    @tags = Tag.page(params[:page])
    @tags = @tags.with_translations(I18n.locale).page(params[:page]).by_name_like(params[:search])  if params[:search].present?

    @tags2 = Tag.page(params[:page])
    @tags2 = @tags2.with_translations(I18n.locale).page(params[:page]).by_name_like(params[:search2])  if params[:search2].present?
  end

  def merge_edit_view
    @tag1 = Tag.find(params[:tag1])
    @tag2 = Tag.find(params[:tag2])
    @newTag = Tag.new
  end

  def merge_by_ids
    toMergeTag = Tag.find(params[:id])
    toMergeTag.articles
    tag = Tag.find(params[:into])
    tag.articles = (tag.articles + toMergeTag.articles).uniq
    tag.save
    toMergeTag.destroy
    redirect_to admin_tags_url
  end

  def create_and_merge
    @tag = Tag.new(tag_params)

    respond_to do |format|
      t1 = Tag.find(params[:id])
      t2 = Tag.find(params[:id2])
      @tag.articles = (t1.articles + t2.articles).uniq
      if @tag.save
        t1.destroy
        t2.destroy
        format.html { redirect_to [:admin, @tag], notice: 'Tag was successfully created.' }
        # format.json { render :show, status: :created, location: @tag }
      else
        format.html { redirect_to :merge_admin_tags, notice: "Tag already exists"}
        # format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end

  end
  # PATCH/PUT /admin/tags/1
  # PATCH/PUT /admin/tags/1.json
  def update
    if params[:migrate_category] != "" 
      migrate_category
      return
    end
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to [:admin, @tag], notice: 'Tag was successfully updated.' }
        # format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit}
        # format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def migrate_category
    categoryId = params[:migrate_category]
    includeTranslation = params[:includeTranslations]
    respond_to do |format|
      if @tag.articles.update_all(category_id: categoryId) && TagToCat.create(slug: @tag.slug,category_id: categoryId)
        if includeTranslation
          c = Category.find(categoryId)
          c.name_zh_hant = @tag.name_zh_hant
          c.name_zh_hans = @tag.name_zh_hans
          c.name_th = @tag.name_th
          c.name_ko = @tag.name_ko
          c.name_vi = @tag.name_vi
          c.name_id = @tag.name_id
          c.save
        end
        @tag.destroy
        format.html { redirect_to admin_tags_url, notice: 'Articles where successfully migrated' }
      else
        format.html { render :edit}
      end
    end
    
  end

  # DELETE /admin/tags/1
  # DELETE /admin/tags/1.json
  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to admin_tags_url, notice: 'Tag was successfully destroyed.' }
      # format.json { head :no_content }
    end
  end

  # GET /admin/tags/search/:query
  # GET /admin/tags/search/:query.js
  # GET /admin/tags/search/:query.json
  def search
    @tag = Tag.new
    l = "en"
    if params.has_key?(:locale)
      I18n.locale =params[:locale]
      l = params[:locale]
    end

    @tags = Tag.with_translations(l).by_name_like(params[:query]).page(params[:page])
    respond_to do |format|
      format.html { render action: :index }
      # format.js
      format.json { render json: @tags.limit(3) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lang
      if(params[:lang])
        I18n.locale = params[:lang]
      else 
        I18n.locale = :en
      end
    end

    def set_tag
      @tag = Tag.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      permitted = Tag.globalize_attribute_names + [:name] + [:parent_id] + [:description] + [:slug]
      params.require(:tag).permit(permitted)
    end
end
