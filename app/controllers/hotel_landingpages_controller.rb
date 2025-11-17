class HotelLandingpagesController < ApplicationController
  def index
    #if(current_user.nil?)
    #  redirect_to  root_path
    #  return true
    #end
    #if User.roles[current_user.role] < User.roles[:registered]
    #  redirect_to  root_path
    #  return
    #end
    cat = Category.find(3)
    add_breadcrumb cat.name, categoryListing_path(cat)
    add_breadcrumb t("hotel-lp.breadcrumb"), hotelp_url
    @hotels = HotelLandingpage.with_translations(I18n.locale).where(published: true).hotel
    @hotels = @hotels.area_filter(Area.find(params[:area])) if params[:area].present?
    @availAreas = @hotels.distinct(:area_id)
    @availAreas = @availAreas.unscoped.pluck(:area_id)
    @areaList = Area.roots.order(:pos)
    @promoHotel = []
    set_meta_tags og: {
      title:    t("hotel-lp.meta_title") ,
      type:     'article',
      url:       request.original_url,
      description: t("hotel-lp.meta_desc"),
      image:    ActionController::Base.helpers.asset_path("assets/hotel_lp.jpg", host: "https://#{ENV['CLOUDFRONT_DOMAIN']}")
    }
    # set_meta_tags twitter: {
    #   card:  "summary_large_image",
    #   title: t("hotel-lp.meta_title"),
    #   description: t("hotel-lp.meta_desc"),
    #   image:  ActionController::Base.helpers.asset_path("assets/hotel_lp.jpg")
    # }
    getPromos()
  end

  private
  def search_params
    params.permit(:query)
  end
  def show_params
    params.permit(:id)
  end
  def getPromos
    promoArt = PickupHotelLp.where(lang: I18n.locale).order(:position)
    promoArt.each do |promo|
      @promoHotel += HotelLandingpage.where(id: promo.hotel_landingpages_id)
    end
  end
end
