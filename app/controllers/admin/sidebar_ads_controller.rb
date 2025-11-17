class Admin::SidebarAdsController < Admin::ApplicationController
  before_action :set_ad, only: [:show, :edit, :update, :destroy, :move]

  def index
    @ads = SidebarAd.all.order(:position)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  def new
    @ad = SidebarAd.new
  end

  def create
    @ad = SidebarAd.new(ad_params)
    @ad.publish_start = time_value(ad_params, :publish_start)
    @ad.publish_end = time_value(ad_params, :publish_end) 

    respond_to do |format|
      if @ad.save
        format.html { redirect_to admin_sidebar_ads_path, notice: 'Ad was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  
  def edit
  end

  def update
    respond_to do |format|
      @ad.attributes = ad_params
      @ad.publish_start = time_value(ad_params, :publish_start)
      @ad.publish_end = time_value(ad_params, :publish_end) 
      if @ad.save
        format.html { redirect_to admin_sidebar_ads_path, notice: 'Ad was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def time_value(hash, field)
    Time.zone.local(*(1..5).map { |i| hash["#{field}(#{i}i)"] }) rescue nil
  end


  def destroy
    @ad.destroy
    respond_to do |format|
      format.html { redirect_to admin_sidebar_ads_path, notice: 'Ad was successfully destroyed.' }
    end
  end

  def move
    @ad.move_to! params[:position]
    # render :nothing => true, :status => 200, :content_type => 'text/html'
    render body: nil
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ad
    @ad = SidebarAd.find(params[:id])
  end

  def ad_params
    params.require(:sidebar_ad).permit(:label, :banner, :analytics_category, :analytics_label, :publish_start, :publish_end, :url)
  end
end
