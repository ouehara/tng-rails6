class Admin::MissingImagesController < Admin::ApplicationController
  include MissingImagesConcern

  # GET /admin/pickups
  # GET /admin/pickups.json
  # @param [String] order Order
  # @param [String] page Pagenation
  def index
    @all = MissingArticlePicture.all
    @all = @all.joins(:article).filter_lang(params[:only_locale]) if params[:only_locale].present?
    @all = @all.page(params[:page])
    @all = @all.sort_lang(params[:asc] == "true" ? "asc": "desc") if params[:sort].present?
    @all = @all.sort_status(params[:asc] == "true" ? "asc" : "desc") if params[:status].present?
    @sort = params[:sort] if params[:sort].present?
    @asc = params[:asc] if params[:asc].present?
  end

  def destroy
    el = MissingArticlePicture.find(params[:id])
    el.destroy
    respond_to do |format|
      format.html { redirect_to admin_missing_images_url, notice: 'Thank you for replacing missing images.' }
      # format.json { head :no_content }
    end
  end

end
