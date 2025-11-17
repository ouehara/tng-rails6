class Admin::AreasController < Admin::ApplicationController
  include AdminOnlyConcern
  before_action :set_lang, only: [:edit, :update]
  before_action :set_area, only: [:show, :edit, :update, :destroy]
  include SortableTreeController::Sort
  sortable_tree 'Area', {parent_method: 'parent'}

  # GET /admin/areas
  # GET /admin/areas.json
  def index
    @area= Area.new
    @items = Area.all.arrange(:order => :pos)
    respond_to do |format|
      format.html
      format.csv { send_data Area.as_csv }
    end
  end

  # GET /admin/areas/1
  # GET /admin/areas/1.json
  def show
  end

  # GET /admin/areas/new
  def new
    @area = Area.new
  end

  # GET /admin/areas/1/edit
  def edit
  end

  # POST /admin/areas
  # POST /admin/areas.json
  def create
    @area = Area.new(area_params)

    respond_to do |format|
      if @area.save
        format.html { redirect_to [:admin, @area], notice: 'Area was successfully created.' }
        # format.json { render :show, status: :created, location: @area }
      else
        format.html { render :new }
        # format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/areas/1
  # PATCH/PUT /admin/areas/1.json
  def update
    if(I18n.locale == :en)
      @area.slug = nil
    end
    respond_to do |format|
      if @area.update(area_params)
        format.html { redirect_to [:admin, @area], notice: 'Area was successfully updated.' }
        # format.json { render :show, status: :ok, location: @area }
      else
        format.html { render :edit }
        # format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    Area.importCSV( params[:area][:import_file] ) 
    redirect_to admin_areas_url
  end
  # DELETE /admin/areas/1
  # DELETE /admin/areas/1.json
  def destroy
    @area.destroy
    respond_to do |format|
      format.html { redirect_to admin_areas_url, notice: 'Area was successfully destroyed.' }
      # format.json { head :no_content }
    end
  end

  # GET /admin/areas/search/:query
  # GET /admin/areas/search/:query.js
  # GET /admin/areas/search/:query.json
  def search
    @root_areas = Area.where(name: params[:query]).page(params[:page])
    respond_to do |format|
      format.html { render action: :index }
      # format.js
      format.json { render json: @areas }
    end
  end

  private
  def set_lang
    if(params[:lang])
      I18n.locale = params[:lang]
    else 
      I18n.locale = :en
    end
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_area
    @area = Area.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def area_params
    params.require(:area).permit(:name,:in_sidebar, :slug, :map_position,:description)
  end
end
