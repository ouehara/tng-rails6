class Admin::ImagesController < Admin::ApplicationController
  def index
    @img = Image.page(params[:page]).per(50).order('id desc')
    @new = Image.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @img = Image.new(images_params)
    
    respond_to do |format|
      if @img.save
        format.html { redirect_to admin_images_url, notice: 'Image was added' }
      else
        format.html { redirect_to admin_images_url, notice: 'Could not add image' }
      end
    end
  end

  def images_params
    params.require(:image).permit(:img)
  end
end