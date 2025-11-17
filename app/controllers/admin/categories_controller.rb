class Admin::CategoriesController < Admin::ApplicationController
  include AdminOnlyConcern
  
  before_action :set_category, only: [:show, :edit, :update, :destroy,:move]
  # GET /admin/categories
  # GET /admin/categories.json
  # @param [String] order Order
  # @param [String] page Pagenation
  def index
    @category = Tag.new
    @c = Category.all.arrange
    @categories = Category.all
    respond_to do |format|
      format.html
      format.csv { send_data Category.as_csv }
    end
    #@categories = @categories.
  end

  # GET /admin/categories/1
  # GET /admin/categories/1.json
  def show
  end

  # GET /admin/categories/new
  def new
    @categories = Category.all.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s 
                  }.sort {|x,y| x.ancestry <=> y.ancestry 
                  }.map{ |c| ["-" * (c.depth - 1) + c.name,c.id] 
                  }.unshift(["-- none --", nil])
    @category = Category.new
  end

  # GET /admin/categories/1/edit
  def edit
    
    @table = @category.root.subtree.arrange
    @categories = Category.all.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s 
                  }.sort {|x,y| x.ancestry <=> y.ancestry 
                  }.map{ |c| ["-" * (c.depth - 1) + c.name,c.id] 
                  }.unshift(["-- none --", nil])
  end

  def import
    Category.importCSV( params[:tag][:import_file] ) 
    redirect_to admin_categories_url
  end

  # POST /admin/categories
  # POST /admin/categories.json
  def create
    @category = Category.new(category_params)
    @categories = @categories = Category.all.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s 
  }.sort {|x,y| x.ancestry <=> y.ancestry 
  }.map{ |c| ["-" * (c.depth - 1) + c.name,c.id] 
  }.unshift(["-- none --", nil])
    respond_to do |format|
      if @category.save
        format.html { redirect_to [:admin, @category], notice: 'Category was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  

  # PATCH/PUT /admin/categories/1
  # PATCH/PUT /admin/categories/1.json
  def update
    if(I18n.locale == :en)
      @category.slug = nil
    end
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to [:admin, @category], notice: 'Category was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /admin/categories/1
  # DELETE /admin/categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to admin_categories_url, notice: 'Category was successfully destroyed.' }
      # format.json { head :no_content }
    end
  end

  # GET /admin/categories/search/:query
  # GET /admin/categories/search/:query.js
  # GET /admin/categories/search/:query.json
  def search
    @categories = Category.by_name_like(params[:query]).page(params[:page])
    respond_to do |format|
      format.html { render action: :index }
      # format.js
      format.json { render json: @categories }
    end
  end

  def move
    @category.move_to! params[:position]
    # render :nothing => true, :status => 200, :content_type => 'text/html'
    render body: nil
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_category
      @category = Category.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :parent_id, :description,:seo_title,:css_class, :active)
    end
end
