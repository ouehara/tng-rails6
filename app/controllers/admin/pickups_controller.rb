class Admin::PickupsController < Admin::ApplicationController
  include AdminOnlyConcern
  before_action :set_pickup, only: [:show, :edit, :update, :destroy, :publish, :unpublish]
  before_action :set_ransack_search_object

  # GET /admin/pickups
  # GET /admin/pickups.json
  # @param [String] order Order
  # @param [String] page Pagenation
  def index
    @pickups = @q.result(distinct: true).page(params[:page]).order('id desc')
  end

  # GET /admin/pickups/1
  # GET /admin/pickups/1.json
  def show
  end

  # GET /admin/pickups/new
  def new
    @pickup = Pickup.new
  end

  # GET /admin/pickups/1/edit
  def edit
  end

  # POST /admin/pickups
  # POST /admin/pickups.json
  def create
    @pickup = Pickup.new(pickup_params)

    respond_to do |format|
      if @pickup.save
        format.html { redirect_to [:admin, @pickup], notice: 'Pickup was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /admin/pickups/1
  # PATCH/PUT /admin/pickups/1.json
  def update
    respond_to do |format|
      if @pickup.update(pickup_params)
        format.html { redirect_to [:admin, @pickup], notice: 'Pickup was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # PATCH/PUT /admin/pickups/1/publish
  def publish
    @pickup.publish
    redirect_to [:admin, @pickup], notice: "Successfully publish this pickup."
  end

  # PATCH/PUT /admin/pickups/1/unpublish
  def unpublish
    @pickup.unpublish
    redirect_to [:admin, @pickup], notice: "Successfully unpublish this pickup."
  end

  # DELETE /admin/pickups/1
  # DELETE /admin/pickups/1.json
  def destroy
    @pickup.destroy
    respond_to do |format|
      format.html { redirect_to admin_pickups_url, notice: 'Pickup was successfully destroyed.' }
      # format.json { head :no_content }
    end
  end

  # GET /admin/pickups/pick_article.js
  def pick_article
    @q = Article.ransack(params[:q])
    respond_to do |format|
      format.js
    end
  end

  def add_articles
  end
  
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pickup
    @pickup = Pickup.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pickup_params
    params.require(:pickup).permit(:title, :content, :image, pickup_articles_attributes: [:id, :article_id, :_destroy])
  end

  # Set search object
  def set_ransack_search_object
    @q = Pickup.includes(:articles).ransack(params[:q])
  end

end
