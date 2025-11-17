class Admin::TopPageSectionsElementsController < Admin::ApplicationController
  before_action :set_top_page_sections_element, only: [:show, :edit, :update, :destroy, :move, :destroy_translation]

  # GET /top_page_sections_elements
  # GET /top_page_sections_elements.json
  def index
    @top_page_sections_elements = TopPageSectionsElement
  end

  # GET /top_page_sections_elements/1
  # GET /top_page_sections_elements/1.json
  def show
  end

  # GET /top_page_sections_elements/new
  def new
    @top_page_sections_element = TopPageSectionsElement.new
  end

  # GET /top_page_sections_elements/1/edit
  def edit
  end

  # POST /top_page_sections_elements
  # POST /top_page_sections_elements.json
  def create
    @top_page_sections_element = TopPageSectionsElement.new(top_page_sections_element_params)

    respond_to do |format|
      if @top_page_sections_element.save
        TopPageSectionsElement.includes(:translations).order(:position).each.with_index(0) do |item, index|
          item.position = index
          item.save
        end  
        format.html { redirect_to admin_top_page_sections_path, notice: 'Top page sections element was successfully created.' }
        format.json { render :show, status: :created, location: @top_page_sections_element }
      else
        format.html { render :new }
        format.json { render json: @top_page_sections_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /top_page_sections_elements/1
  # PATCH/PUT /top_page_sections_elements/1.json
  def update
    respond_to do |format|
      if @top_page_sections_element.update(top_page_sections_element_params)
        format.html { redirect_to admin_top_page_sections_path, notice: 'Top page sections element was successfully updated.' }
        format.json { render :show, status: :ok, location: @top_page_sections_element }
      else
        format.html { render :edit }
        format.json { render json: @top_page_sections_element.errors, status: :unprocessable_entity }
      end
    end
  end

  def move
    @top_page_sections_element.move_to! params[:position]
    # render :nothing => true, :status => 200, :content_type => 'text/html'
    render body: nil
  end
  # DELETE /top_page_sections_elements/1
  # DELETE /top_page_sections_elements/1.json
  def destroy
    @top_page_sections_element.destroy
    respond_to do |format|
      format.html { redirect_to admin_top_page_sections_path, notice: 'Top page sections element was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_translation
    translation_locale = I18n.locale
    if @top_page_sections_element.translations.count > 1
      Globalize.with_locale(translation_locale) do
        @top_page_sections_element.translation.destroy
        message = %(Deleted #{translation_locale} translation successfully.)
      end
    else
      message = %(#{translation_locale} is the only translation left and cannot be deleted. Delete the record, instead.)
    end
    respond_to do |format|
    format.html { redirect_to admin_top_page_sections_path, notice: message}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_top_page_sections_element
      @top_page_sections_element = TopPageSectionsElement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def top_page_sections_element_params
      params.require(:top_page_sections_element).permit(:title, :link, :image, :top_page_section_id)
    end
end
