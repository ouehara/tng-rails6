class Admin::TopPageSectionsController < Admin::ApplicationController
  before_action :set_top_page_section, only: [:show, :edit, :update, :destroy]

  # GET /top_page_sections
  # GET /top_page_sections.json
  def index
    @top_page_sections = TopPageSection.all.order("id")
  end

  # GET /top_page_sections/1
  # GET /top_page_sections/1.json
  def show
  end

  # GET /top_page_sections/new
  def new
    @top_page_section = TopPageSection.new
  end

  # GET /top_page_sections/1/edit
  def edit
  end

  # POST /top_page_sections
  # POST /top_page_sections.json
  def create
    @top_page_section = TopPageSection.new(top_page_section_params)

    respond_to do |format|
      if @top_page_section.save
        format.html { redirect_to admin_top_page_sections_path, notice: 'Top page section was successfully created.' }
        format.json { render :show, status: :created, location: @top_page_section }
      else
        format.html { render :new }
        format.json { render json: @top_page_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /top_page_sections/1
  # PATCH/PUT /top_page_sections/1.json
  def update
    respond_to do |format|
      @top_page_section.selected_template = top_page_section_params["selected_template"]
      if @top_page_section.update(top_page_section_params)
        format.html { redirect_to admin_top_page_sections_path, notice: 'Top page section was successfully updated.' }
        format.json { render :show, status: :ok, location: @top_page_section }
      else
        format.html { render :edit }
        format.json { render json: @top_page_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /top_page_sections/1
  # DELETE /top_page_sections/1.json
  def destroy
    @top_page_section.destroy
    respond_to do |format|
      format.html { redirect_to admin_top_page_sections_path, notice: 'Top page section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_top_page_section
      @top_page_section = TopPageSection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def top_page_section_params
      params.require(:top_page_section).permit(:title, :selected_template, :more_btn_text, :more_btn_link, :active)
    end
end
