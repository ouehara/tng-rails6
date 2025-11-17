class ImageController < ApplicationController

  include ImagesUploadConcern
  def index
    @img = Image.page(params[:page]).per(50)
    respond_to do |format|
      format.json { render json: {img: @img.to_json(:methods => [:medium_url, :original_url]), current: @img.current_page, total: @img.total_pages}, status: :created }
    end
  end

  def create
    if !shouldAllowUpload
      render json: []
      return
    end
    @img = Image.new(images_params)
    respond_to do |format|
      if @img.save
        format.json { render json: @img.to_json(:methods => [:medium_url,:original_url]), status: :created }
      else
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def images_params
    params.permit(:img)
  end

end