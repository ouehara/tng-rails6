class RestaurantSearchController < ApplicationController
  include SavorEditConcern
  include Conf
  def index
    @restaurantList = getRestaurant
    @results = []
    @articles = Article.get_cached_articles_for_cat(1).to_json(:methods => [:thumb_url, :cached_users])
    add_breadcrumb "Food and Drink", categoryListing_url("food-drink")
    add_breadcrumb "Restaurant Search", restaurant_search_index_url
    set_meta_tags title: t("savor.search_title")
    set_meta_tags og: {
      # title: t("savor.search_title"),
      image: "https://www.tsunagujapan.com/assets/t0007_008_20171208044443_w640z.jpg"
    }
  end

  def search
    page = 1
    add_breadcrumb "Food and Drink", categoryListing_url("food-drink")
    add_breadcrumb "Restaurant Search", restaurant_search_index_url
    if(params.has_key?(:page))
      page = params[:page]
    end
    locations = SavorLandmark.where(:spot_name => params[:location]).first  if params[:location].present? && params[:loc_type]  == "landmark"
    locations = SavorLocation.where(:pref => params[:location])  if params[:location].present? && params[:loc_type]  == "prefectures"
    locations = SavorLocation.where(:township => params[:location])  if params[:location].present? && params[:loc_type]  == "town"
    locations = SavorLocation.where(:sub_township => params[:location])  if params[:location].present? && params[:loc_type]  == "subTown"

    if params[:location].present? && params[:loc_type]  == ""
      params[:keywords] = params[:location]
      params[:location] = ""
    end

    @results = SavorRestaurant.where(nil)
    @results = @results.where("pref_code = ? AND township_code=?",locations.pref_code,locations.township_code) if !locations.nil? && params[:loc_type]  == "landmark"

    @results = @results.where("pref_code IN (?)",locations.group(:pref_code).pluck(:pref_code)) if !locations.nil? && params[:loc_type]  == "prefectures"
    @results = @results.where("township_code = ?",locations.group(:township_code).pluck(:township_code)) if !locations.nil? && params[:loc_type]  == "town"
    @results = @results.where("sub_township_code IN (?)",locations.group(:sub_township_code).pluck(:sub_township_code)) if !locations.nil? && params[:loc_type]  == "subTown"

    @results = @results.where("average_price_lunch >= ? AND average_price_lunch <= ?", params[:budget_from], params[:budget_to] == "-1" ? 1000000 : params[:budget_to]) if params[:budget]  == "lunch" && (params[:budget_from] != "-1" || params[:budget_to] != "-1")
    @results = @results.where("average_price_grand >= ? AND average_price_grand <= ?", params[:budget_from], params[:budget_to] == "-1" ? 1000000 : params[:budget_to]) if params[:budget]  == "dinner" && (params[:budget_from] != "-1" || params[:budget_to] != "-1")
    @results = @results.with_translations(get_lang).filters(params.slice(:cuisine_id,:sub_cuisine_id, :no_smoking, :menu,:languages_available,:late_night_service, :special_diet,:western_cutlery,:lunch_menu,:free_wifi_available,:master_card,:visa,:american_express,:diners_club,:coupons))

    @results = @results.ransack(translations_name_or_translations_station_1_or_translations_station_2_or_translations_address_cont: params[:keywords]).result(distinct: true) if params[:keywords].present?
    cusine = SavorRestaurantCuisineType.with_translations(get_lang).where(:category_type => "cuisine").ransack(translations_small_category_or_translations_large_category_cont: params[:keywords]).result(distinct: true).pluck(:id) if params[:keywords].present?
    a = @results.where("(cuisine_code_1 IN (:query) OR cuisine_code_2 IN (:query) OR cuisine_code_2 IN (:query))",:query => cusine.map(&:to_s)) if !cusine.nil? && !cusine.empty?
    @results.where([a,  @results].map{|s| s.arel.constraints.reduce(:and) }.reduce(:or))\
    .tap {|sc| sc.bind_values = [a, @results].map(&:bind_values) } if !cusine.nil? && !cusine.empty?

    @search_params = params.clone.except(:utf8,:locale,:page,:sub_cuisine_id, :controller,:action, :loc_type,:budget,:budget_from,:budget_to,:cuisine_id, :order_by).reject { |k,v| v.nil? || v.empty? }
    sort_params = {
    "price_desc" => "savor_restaurant_translations.ad DESC, savor_restaurants.average_price_lunch, savor_restaurants.average_price_grand DESC",
    "price_asc" => "savor_restaurant_translations.ad DESC, savor_restaurants.average_price_lunch, savor_restaurants.average_price_grand ASC NULLS LAST",
    "name" => "savor_restaurant_translations.ad DESC, (COALESCE(savor_restaurants.no_smoking,0) + COALESCE(savor_restaurant_translations.menu::int,0) + COALESCE(savor_restaurant_translations.languages_available,0) + COALESCE(savor_restaurants.late_night_service,0) + COALESCE(savor_restaurants.special_diet,0) + COALESCE(savor_restaurants.western_cutlery,0) + COALESCE(savor_restaurants.lunch_menu,0) + COALESCE(savor_restaurants.free_wifi_available,0)) DESC, savor_restaurant_translations.name ASC"
    }


    @results = @results.select("(COALESCE(savor_restaurants.no_smoking,0) + COALESCE(savor_restaurant_translations.menu::int,0) + COALESCE(savor_restaurant_translations.languages_available,0) + COALESCE(savor_restaurants.late_night_service,0) + COALESCE(savor_restaurants.special_diet,0) + COALESCE(savor_restaurants.western_cutlery,0) + COALESCE(savor_restaurants.lunch_menu,0) + COALESCE(savor_restaurants.free_wifi_available,0))").where(:target => 1).order(sort_params[params[:order_by] || "name"]).page(page).includes(:translations).per(Rails.configuration.elements_per_page)
    @results_text = t("savor.search_results",start:
    @results.offset_value + 1, end: [Rails.configuration.elements_per_page*page.to_i,@results.total_count].min,
    all:  @results.total_count)
    @show_admin_options = shouldAllowEdit
    #@from = @results.offset_value + 1 ;
    set_meta_tags :nofollow => true
    #@to = @results.total_count
  end

  def autocomplete_landmark_location
    # autocomplete by prefecture
    pref = SavorLocation.with_translations(get_lang).ransack(translations_pref_cont: params[:term])
    prefRes = pref.result.select("pref").limit(3).group("pref")
    # autocomplete by town
    town = SavorLocation.with_translations(get_lang).ransack(translations_township_cont: params[:term])
    townRes = town.result(distinct: true).select("township").limit(3).group("township")
    # autocomplete by sub town
    subTown = SavorLocation.with_translations(get_lang).ransack(translations_sub_township_cont: params[:term])
    subTownRes = subTown.result(distinct: true).limit(3)
    # autocomplete by landmark
    landmark = SavorLandmark.with_translations(get_lang).ransack(translations_spot_name_cont: params[:term])
    landmarkRes = landmark.result(distinct: true).limit(3)
    render :json => {prefectures: prefRes, town: townRes, subTown: subTownRes, landmark: landmarkRes}
    #head :ok, content_type: "text/html"
  end

  def autocomplete_cuisine
    cuisine = SavorRestaurantCuisineType.with_translations(get_lang).where(:category_type => "cuisine").ransack(translations_large_category_cont: params[:term])
    cuisineRes = cuisine.result(distinct: true).select("large_category_code, large_category").group("large_category_code, large_category").limit(5)

    cuisineSmall = SavorRestaurantCuisineType.with_translations(get_lang).where(:category_type => "cuisine").ransack(translations_small_category_cont: params[:term])
    cuisineSmallRes = cuisineSmall.result(distinct: true).select("small_category, small_category_code").group("small_category, small_category_code").limit(5)

    a = cuisineRes.to_a + cuisineSmallRes.to_a

    render :json => a
  end

  def get_lang
    if I18n.locale.to_s ==  "th" ||  I18n.locale.to_s == "vi"  ||  I18n.locale.to_s == "ko"
      return :en.to_s
    end
    return I18n.locale.to_s
  end
end
