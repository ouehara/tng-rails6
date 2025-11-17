

class PagesController < ApplicationController
  include Conf
  protect_from_forgery except: :new

    def show
      @i18n = I18n.locale.to_s
      render template: "pages/#{params[:id]}"
    end

    def special_offer
      @i18n = I18n.locale.to_s
      add_breadcrumb 'Edion', url_for
      render template: "offer/#{params[:id]}"
    end

    def feature_hokkaido
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "area_feature", template: "areas/feature/hokkaido"
    end

    def feature_tohoku
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "area_feature", template: "areas/feature/tohoku"
    end

    def feature_kyushu
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "area_feature", template: "areas/feature/kyushu"
    end

    def feature_okinawa
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "area_feature", template: "areas/feature/okinawa"
    end

    def feature_shikoku
      @i18n = I18n.locale.to_s
      @description = "description"
      @keywords = ''
      render :layout => "area_feature", template: "areas/feature/shikoku"
    end

    def feature_setouchi
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "area_feature", template: "areas/feature/setouchi"
    end

    def feature_kanto
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "area_feature", template: "areas/feature/kanto"
    end

    def feature_kansai
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "area_feature", template: "areas/feature/kansai"
    end

    def feature_chubu
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "area_feature", template: "areas/feature/chubu"
    end

    def feature_chugoku
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "area_feature", template: "areas/feature/chugoku"
    end

    def feature_gunma
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"

      # PRODUCTION
      featuredIds = {
        # "en" => [40533, 40832, 40883, 40378]
        "en" => [41192, 41090, 41190, 41197, 40883, 40928],
      }

      @featured = Article.includes([:translations]).includes([:area]).translation_published(I18n.locale).find(featuredIds[I18n.locale.to_s])
      render :layout => "area_feature_prefecture", template: "areas/feature/prefectures/gunma"
    end

    def setouchi_newsletter
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "area_feature_prefecture", template: "newsletter/setouchi"
    end

    def gunma_excellence
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "area_feature_prefecture", template: "areas/feature/prefectures/gunma_excellence"
    end

    def gunma_excellence_b
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "area_feature_prefecture", template: "areas/feature/prefectures/gunma_excellence_b"
    end

    def experience_echigo
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "category_feature", template: "category/feature/experience_echigo"
    end

    def feature_index
      add_breadcrumb t('feature.feature_label'), :category_feature_index_path
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render template: "category/feature/index"
    end

    def feature_poj
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "category_feature", template: "category/feature/poj"
    end

    def feature_aoj_a
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "category_feature", template: "category/feature/aoj_a"
    end

    def feature_aoj_b
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "category_feature", template: "category/feature/aoj_b"
    end

    def feature_aoj_c
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "category_feature", template: "category/feature/aoj_c"
    end

    def feature_aoj_d
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "category_feature", template: "category/feature/aoj_d"
    end

    def feature_aoj_e
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "category_feature", template: "category/feature/aoj_e"
    end

    def feature_coj_b
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "category_feature", template: "category/feature/coj_b"
    end

    def feature_coj_c
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "category_feature", template: "category/feature/coj_c"
    end

    def feature_coj_d
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "category_feature", template: "category/feature/coj_d"
    end

    def feature_coj_e
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "category_feature", template: "category/feature/coj_e"
    end

    def feature_coj_f
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render :layout => "category_feature", template: "category/feature/coj_f"
    end

    def tj_jobs
      add_breadcrumb t('jobs.title'), :tsunagu_japan_jobs_path
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render template: "jobs/tj_jobs"
    end

    def tj_dmc
      add_breadcrumb t('dmc.title'), :tsunagu_japan_dmc_path
      @i18n = I18n.locale.to_s
      @title = "title"
      @description = "description"
      render template: "dmc/tj_dmc"
    end

    def corona_detail
      @langkey = "transport"
      @establishment = HotelLandingpage.with_translations(I18n.locale).where(published: true)
      @tab = params.has_key?(:tab) ? params[:tab] : ""
      if @tab == "hotels"
        @langkey="accommodate"
        @establishment = @establishment.c_hotel
        render :layout => "full", template: "corona/details"
        return
      end
      if @tab == "transportation"
        @langkey= "transport"
        @establishment = @establishment.c_transport
        render :layout => "full", template: "corona/details"
        return
      end
      if @tab == "restaurants"
        @langkey="restaurant"
        @establishment = @establishment.c_restaurant
        render :layout => "full", template: "corona/details"
        return
      end
      if @tab == "shops"
        @langkey="shops"
        @establishment = @establishment.c_shops
        render :layout => "full", template: "corona/details"
        return
      end
      if @tab == "sightseeing"
        @langkey="sightseeing"
        @establishment = @establishment.c_sightseeing
        render :layout => "full", template: "corona/details"
        return
      end
      if @tab == "others"
        @langkey="other"
        @establishment = @establishment.c_other
        render :layout => "full", template: "corona/details"
        return
      end
      if @tab != ""
        raise ActionController::RoutingError.new('Not Found')
        return
      end
      @establishment = @establishment.where.not(category: HotelLandingpage.categories[:hotel])
      @langkey=""

      render :layout => "full", template: "corona/details"
    end

    def category_detail
      @langkey = "transport"
      @establishment = HotelLandingpage.includes([:hotel_images]).includes([:hotel_features]).includes([:area]).with_translations(I18n.locale).where(published: true)
      @tab = params.has_key?(:tab) ? params[:tab] : ""
      @areas = Area.includes([:translations])
      @area_ids = []

      case @tab

      when "hotels" then
        @langkey="accommodate"
        @establishment = @establishment.c_hotel.order(:name)
      when "transportation" then
        @langkey= "transport"
        @establishment = @establishment.c_transport.order(:name)
      when "restaurants" then
        @langkey="restaurant"
        @establishment = @establishment.c_restaurant.order(:name)
      when "shops" then
        @langkey="shops"
        @establishment = @establishment.c_shops.order(:name)
      when "sightseeing" then
        @langkey="sightseeing"
        @establishment = @establishment.c_sightseeing.order(:name)
      when "others" then
        @langkey="other"
        @establishment = @establishment.c_other.order(:name)
      end

      @establishment = @establishment.where.not(category: HotelLandingpage.categories[:hotel]).order(:name)
      @langkey=""

      @establishment.each.with_index do |hotel, index|
        @area_ids.push(hotel.area_id)
      end

      # # 親エリアリスト
      # # @areaList = Area.roots.order(:pos)
      #

      @area_ids = @area_ids.uniq
      if @area_ids.include?(-1)
        @area_ids.delete(-1)
      end
      @areas = @areas.order(pos: "asc").find(@area_ids)

      # @aaa = area_additional(61, 472)

      # render json: @aaa
      render :layout => "traveling_safe_in_japan_detail", template: "corona/category_detail"
    end

    def corona

      # PRODUCTION
      featuredIds = {
        "en" => [40533, 40832, 40883, 40378, 40743],
        "zh-hant"=> [40876, 26087, 26129, 40437, 39723],
        "zh-hans"=> [39253, 39319, 40789, 39264, 27873],
        "th"=> [39570, 39467, 39020, 40349, 40105],
        "vi"=> [40743, 40962, 40843, 39479, 40533],
        "ko"=> [40378, 40743, 40838, 40876, 40861],
        "id"=> [39479, 26870, 40743, 40900, 40544]
      }

      # staging
      # featuredIds = {
      #   "en" => [40184, 40221, 40414, 40321],
      #   "zh-hant"=> [40184, 40221, 40414],
      #   "zh-hans"=> [40184, 40221, 40414],
      #   "th"=> [40184, 40221, 40414],
      #   "vi"=> [40184, 40221, 40414],
      #   "ko"=> [40184],
      #   "id"=> [40184, 40221, 40414]
      # }

      set_meta_tags og: {
        url:       request.original_url,
        image:  ActionController::Base.helpers.asset_pack_path("media/images/covid/travelingTeaser.jpg", host: "https://#{ENV['CLOUDFRONT_DOMAIN']}")
      }
      # set_meta_tags twitter: {
      #   card:  "summary_large_image",
      #   title:    I18n.t("covid.teaster.headline_html"),
      #   description: I18n.t("covid.teaster.sub"),
      #   image:  ActionController::Base.helpers.asset_pack_path("media/images/covid/travelingTeaser.jpg"),
      # }

      @featured = Article.includes([:translations]).includes([:area]).translation_published(I18n.locale).find(featuredIds[I18n.locale.to_s])

      @establishment = HotelLandingpage.with_translations(I18n.locale).where(published: true)
      @establishment = @establishment.where.not(category: HotelLandingpage.categories[:hotel])
      @langkey = "transport"

      render :layout => "traveling_safe_in_japan", template: "corona/index"

    end

  def area_additional(hotelId, areaId)
    @areas = Area.includes([:translations])

    case hotelId
    when 1058 then
      @area_ids = [ 1, 199, 188, 205, 226, 171, 182, 194, 253, 238, 282, 264, 320, 338, 274, 311, 299, 31, 74, 65, 40, 54, 46, 377, 350, 367, 357, 383, 413, 405, 392, 398, 447, 435, 420, 430, 454, 464, 482, 472, 125, 85, 116, 110, 152, 101, 93 ]
    when 1052 then
      @area_ids = [ 125, 31, 40, 46, 54, 65, 74, 85, 116, 93, 101, 110, 152, 171, 199, 205, 238 ]
    when 57 then
      @area_ids = [ 125, 152, 110, 101, 116, 238, 199, 226, 282, 299, 253 ]
    when 1057 then
      @area_ids = [ 299, 311, 282 ]
    when 23 then
      @area_ids = [ 299, 282, 274 ]
    when 33 then
      @area_ids = [ 299, 182, 188, 194, 171, 205, 274, 282, 311, 320, 338, 367, 377, 383, 350, 357, 377, 420 ]
    when 100 then
      @area_ids = [ 125, 152 ]
    when 101 then
      @area_ids = [ 125, 152 ]
    when 1003 then
      @area_ids = [ 125, 282, 299 ]
    when 28 then
      @area_ids = [ 282, 299, 338, 367, 377, 282, 311, 320 ]
    when 26 then
      @area_ids = [ 125, 1, 31, 40, 46, 54, 65, 74, 152, 110, 116, 85, 101, 93, 188, 171, 182, 194, 205, 226, 199, 264, 238, 253, 311, 282, 274, 299, 320, 338, 357, 350, 367, 383, 377, 398, 405, 392, 413, 420, 430, 454, 435, 447, 464, 472, 482 ]
    when 95 then
      @area_ids = [ 125, 1, 46, 54, 65, 74, 85, 93, 101, 110, 116, 152, 171, 205, 199, 238, 253, 226, 264, 282, 299, 311, 320, 338, 182, 188, 194, 350, 357, 367, 377, 383, 398, 413, 420, 430, 435, 447, 454, 464, 472 ]
    when 96 then
      @area_ids = [ 125, 188, 253, 282, 299, 311, 367, 377, 383, 420 ]
    when 93 then
      @area_ids = [ 125, 299, 282, 226, 311, 420, 264, 320 ]
    when 102 then
      @area_ids = [ 125, 152 ]
    when 1100 then
      @area_ids = [ 125, 31, 40, 46, 54, 65, 74, 85, 93, 101, 110, 116, 152, 171, 182, 188, 194, 199, 205, 226, 238, 253, 264, 274, 282, 299, 311, 320, 338, 350, 357, 367, 377, 383, 392, 398, 405, 413, 420, 430, 435, 447, 454, 464, 472, 482 ]
    when 34 then
      @area_ids = [ 125, 1, 31, 40, 46, 54, 65, 74, 85, 93, 101, 110, 116, 152, 171, 182, 188, 194, 199, 205, 226, 238, 253, 264, 274, 282, 299, 311, 320, 338, 350, 357, 367, 377, 383, 392, 398, 405, 413, 420, 430, 435, 447, 454, 464, 472, 482 ]
    when 1151 then
      @area_ids = [ 125, 1, 31, 40, 46, 54, 65, 74, 152, 110, 116, 85, 101, 93, 299, 311, 282, 320, 274, 338, 367, 377, 350, 357, 383, 392, 398, 405, 413, 420, 430, 435, 447, 454, 464, 472, 482 ]
    when 25 then
      @area_ids = [ 125, 1, 46, 152, 110, 116, 101, 205, 238, 253, 264, 188, 299, 282, 320, 311, 274, 367, 377, 383, 405, 420, 435, 447, 454, 464, 472, 482 ]
    when 41 then
      @area_ids = [ 125, 1, 46, 110, 116, 152, 205, 299, 367 ]
    when 46 then
      @area_ids = [ 125, 1, 31, 40, 46, 74, 152, 116, 110, 85, 93, 171, 199, 205, 226, 238, 253, 299, 311 ]
    when 47 then
      @area_ids = [ 125, 152, 110, 116, 101, 299, 282, 226, 367, 253, 405, 350 ]
    when 105 then
      @area_ids = [ 125, 152, 110, 101, 205, 46, 65, 40, 54, 1, 74, 171, 93, 116, 31, 85 ]
    when 110 then
      @area_ids = [ 182 ]
    when 111 then
      @area_ids = [ 182 ]
    else
      @area_ids = [areaId]
    end

    # 未登録のものが来た場合
    @area_ids.delete(-1)

    @areas.order(pos: "asc").find(@area_ids).pluck(:id, :name, :pos)

  end

  def planning
    @i18n = I18n.locale.to_s
    @title = "title"
    @description = "description"
    @keywords = ''
    render :layout => "planning_trip", template: "planning_a_trip_to_japan/index"
  end

  helper_method :area_additional

  end
