
class Admin::HotelLandingpagesController < Admin::ApplicationController
  before_action :set_hotel_landingpage, only: [:show, :edit, :update, :destroy, :destroy_image]
  def index
    @htlp = HotelLandingpage.new
    @lang = I18n.locale
    if params.has_key?(:set_locale)
      @lang = params[:set_locale]
    end 
    @admin_hotel_landingpages = HotelLandingpage.all
    hotelPickup = PickupHotelLp.where(lang: @lang)
    leftPromoHotel = hotelPickup.find_by_position(PickupHotelLp.positions[:left]) unless hotelPickup.nil?
    centerPromoHotel = hotelPickup.find_by_position(PickupHotelLp.positions[:middle]) unless hotelPickup.nil?
    rightPromoHotel = hotelPickup.find_by_position(PickupHotelLp.positions[:right]) unless hotelPickup.nil?
    @leftPromo = HotelLandingpage.find_by_id(leftPromoHotel.hotel_landingpages_id) unless leftPromoHotel.nil?
    @middlePromo = HotelLandingpage.find_by_id(centerPromoHotel.hotel_landingpages_id) unless centerPromoHotel.nil?
    @rightPromo = HotelLandingpage.find_by_id(rightPromoHotel.hotel_landingpages_id) unless rightPromoHotel.nil?
    respond_to do |format|
      format.html
      format.csv { send_data HotelLandingpage.as_csv }
    end
  end

  def new
    @admin_hotel_landingpage = HotelLandingpage.new
    @areas = Area.roots.includes(:translations)
  end

  def show
  end

  def destroy_pickup
    pickup = PickupHotelLp.find(params[:id])
    pickup.destroy
    respond_to do |format|
      format.html { redirect_to admin_hotel_landingpages_url }
    end
  end

  def move
    @hotel_lp = HotelLandingpage.find(params[:id])
    @hotel_lp.move_to! params[:position]
    # render :nothing => true, :status => 200, :content_type => 'text/html'
    render body: nil
  end

  def edit
    @lang = "en"
    if params.has_key?(:set_locale)
      @lang = params[:set_locale]
    end 
    I18n.locale = @lang
    @promo = @admin_hotel_landingpage.pickup_hotel_lp.find_by_lang(I18n.locale)
    @areas = Area.roots.includes(:translations)
  end

  def create
    @hotel = HotelLandingpage.new(hotel_params)

    respond_to do |format|
      if @hotel.save
        if params[:hotel_images]
          params[:hotel_images].each do |image|
            @hotel.hotel_images.create(image: image)
          end
        end
        format.html { redirect_to  admin_hotel_landingpages_url, notice: 'Hotel was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @lang = "en"
    if params.has_key?(:set_locale)
      @lang = params[:set_locale]
    end 
    if(params.has_key?(:isPromotional) && params[:isPromotional] != "-1")
      PickupHotelLp.
      update_or_create_by(
        {lang:  @lang, position: PickupHotelLp.positions[params[:isPromotional]]},
        {hotel_landingpages_id: @admin_hotel_landingpage.id, position: params[:isPromotional]}
      )
    end
    I18n.locale = @lang
    respond_to do |format|
      if @admin_hotel_landingpage.update(hotel_params)
        if params[:hotel_images]
          params[:hotel_images].each do |image|
            @admin_hotel_landingpage.hotel_images.create(image: image)
          end
        end
        if params[:hotel_features]
          @admin_hotel_landingpage.hotel_features.destroy_all
          params[:hotel_features].each do |feature|
            @admin_hotel_landingpage.hotel_features.create(feature: feature.to_i)
          end
        end
        
        format.html { redirect_to edit_admin_hotel_landingpage_url(@admin_hotel_landingpage), notice: 'Hotel was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @admin_hotel_landingpage.destroy
    respond_to do |format|
      format.html { redirect_to admin_hotel_landingpages_url, notice: 'Hotel was successfully destroyed.' }
      # format.json { head :no_content }
    end
  end

  def destroy_image
    image = @admin_hotel_landingpage.hotel_images.find(params[:img_id])
    image.destroy
    render :nothing => true, :status => 200, :content_type => 'text/html'    
  end

  def pick_lang
    respond_to do |format|
      format.js
    end
  end

  def select_pick
    @admin_hotel_landingpages = HotelLandingpage.with_translations(params[:lang])
    respond_to do |format|
      format.html
    end
  end

  def import
    HotelLandingpage.importCSV( params[:hotel_landingpage][:import_file] ) 
    redirect_to admin_tags_url
  end

  private 

  def set_hotel_landingpage
    @admin_hotel_landingpage = HotelLandingpage.find(params[:id])
  end

  def hotel_params
    params.require(:hotel_landingpage).permit(:recommend_text, :official_text, :name, :description, :price, :summary, :url, :address, :area_id,:hotel_images, :category, :maps,:img_src,:published,hotel_landingpage_articles_attributes: [:id, :article_id, :_destroy])
  end

end
