require 'csv'
require 'open-uri'
namespace :import_restaurants do
  path = "https://savorjapan.com/site_linkage/tsunagu/"
  fileSuffix =  Time.now.strftime("%Y%m%d")
  #fileSuffix = "all_201803"
  auth_user = "tsunagu_Japan"
  auth_pw = "Jx6mCgzhUm"
  task :coupon => :environment do
    csv_text = open("#{path}coupon_#{fileSuffix}.csv",
    http_basic_authentication: [auth_user, auth_pw])
    CSV.foreach(csv_text,  encoding: "bom|utf-8", headers: true) do |row|
      if SavorCoupon.exists?(:restaurant_code => row["restaurant_code"])
        coupon = SavorCoupon.find_by_restaurant_code(row["restaurant_code"])
      else
        coupon = SavorCoupon.new
        coupon.restaurant_code = row["restaurant_code"]
      end
      if(row.key?('add_mode') && row["add_mode"] == "DELETE")
        coupon.destroy
        next
      end
      #base attributes
      coupon.coupon_code = row["coupon_code"]
      #translated
      coupon.target_en = row["target_en"]
      coupon.target_zh_hant = row["target_tw"]
      coupon.target_zh_hans = row["target_cn"]

      coupon.coupon_title_en = row["coupon_title_en"]
      coupon.coupon_title_zh_hant = row["coupon_title_tw"]
      coupon.coupon_title_zh_hans = row["coupon_title_cn"]
      coupon.coupon_title_ja = row["coupon_jp_title"]

      coupon.coupon_description_en = row["coupon_description_en"]
      coupon.coupon_description_zh_hant = row["coupon_description_tw"]
      coupon.coupon_description_zh_hans = row["coupon_description_cn"]
      coupon.coupon_description_ja = row["coupon_jp_description"]
      
      coupon.coupon_available_from_en = row["coupon_available_from_en"]
      coupon.coupon_available_from_zh_hant = row["coupon_available_from_tw"]
      coupon.coupon_available_from_zh_hans = row["coupon_available_from_cn"]
      
      coupon.coupon_available_to_en = row["coupon_available_to_en"]
      coupon.coupon_available_to_zh_hant = row["coupon_available_to_tw"]
      coupon.coupon_available_to_zh_hans = row["coupon_available_to_cn"]

      coupon.coupon_publish_from_en = row["coupon_publish_from_en"]
      coupon.coupon_publish_from_zh_hant = row["coupon_publish_from_tw"]
      coupon.coupon_publish_from_zh_hans = row["coupon_publish_from_cn"]

      coupon.coupon_publish_to_en = row["coupon_publish_to_en"]
      coupon.coupon_publish_to_zh_hant = row["coupon_publish_to_tw"]
      coupon.coupon_publish_to_zh_hans = row["coupon_publish_to_cn"]
      coupon.save

    end
  end
  task :menu => :environment do
    csv_text = open("#{path}menu_#{fileSuffix}.csv",
    http_basic_authentication: [auth_user, auth_pw])
    CSV.foreach(csv_text,  encoding: "bom|utf-8", headers: true) do |row|
      if SavorMenu.exists?(:restaurant_code => row["restaurant_code"])
        menu = SavorMenu.find_by_restaurant_code(row["restaurant_code"])
      else
        menu = SavorMenu.new
        menu.restaurant_code = row["restaurant_code"]
      end
      if(row.key?('add_mode') && row["add_mode"] == "DELETE")
        menu.destroy
        next
      end
      #base attributes
      menu.menu_code = row["menu_code"]
      menu.menu_type = row["menu_type"]
      menu.carry_page = row["carry_page"]
      #translated attributes
      menu.target_en = row["target_en"]
      menu.target_zh_hant = row["target_tw"]
      menu.target_zh_hans = row["target_cn"]

      menu.menu_name_en = row["menu_name_en"]
      menu.menu_name_zh_hant = row["menu_name_tw"]
      menu.menu_name_zh_hans = row["menu_name_cn"]

      menu.menu_caption_en = row["menu_caption_en"]
      menu.menu_caption_zh_hant = row["menu_caption_tw"]
      menu.menu_caption_zh_hans = row["menu_caption_cn"]

      menu.menu_price_en = row["menu_price_en"]
      menu.menu_price_zh_hant = row["menu_price_tw"]
      menu.menu_price_zh_hans = row["menu_price_cn"]

      menu.menu_photo_en = row["menu_photo_en"]
      menu.menu_photo_zh_hant = row["menu_photo_tw"]
      menu.menu_photo_zh_hans = row["menu_photo_cn"]

      menu.save

    end
  end
  task :image => :environment do
    csv_text = open("#{path}photo_#{fileSuffix}.csv",
    http_basic_authentication: [auth_user, auth_pw])
    CSV.foreach(csv_text,  encoding: "bom|utf-8", headers: true) do |row|
      if SavorImageData.exists?(:restaurant_code => row["restaurant_code"])
        image = SavorImageData.find_by_restaurant_code(row["restaurant_code"])
      else
        image = SavorImageData.new
        image.restaurant_code = row["restaurant_code"]
      end
      
      image.lang = row["lang"]
      image.photo = row["photo"]
      image.photo_genre = row["photo_genre"]
      image.photo_caption = row["photo_caption"]
      image.information_flag = row["information_flag"]
      image.search_result_flag = row["search_result_flag"]
      image.save
    end
  end
  task :location => :environment do
    csv_text = open("#{path}location_#{fileSuffix}.csv",
    http_basic_authentication: [auth_user, auth_pw])
    CSV.foreach(csv_text,  encoding: "bom|utf-8", headers: true) do |row|
      location = SavorLocation.new
      location.pref_code = row["pref_code"]
      location.township_code = row["township_code"]
      location.sub_township_code = row["sub_township_code"]
      #translated
      location.pref_ja = row["jp_pref"]
      location.pref_en = row["pref_en"]
      location.pref_zh_hant = row["pref_tw"]
      location.pref_zh_hans = row["pref_cn"]

      location.township_ja = row["jp_township"]
      location.township_en = row["township_en"]
      location.township_zh_hant = row["township_tw"]
      location.township_zh_hans = row["township_cn"]

      location.sub_township_ja = row["jp_sub_township"]
      location.sub_township_en = row["sub_township_en"]
      location.sub_township_zh_hant = row["sub_township_tw"]
      location.sub_township_zh_hans = row["sub_township_cn"]
      location.save
    end
  end
  task :landmark => :environment do 
    csv_text = open("#{path}landmark_#{fileSuffix}.csv",
    http_basic_authentication: [auth_user, auth_pw])
    CSV.foreach(csv_text,  encoding: "bom|utf-8", headers: true) do |row|
      if SavorLandmark.exists?(:id => row["spot_id"])
        landmark = SavorLandmark.find_by_id(row["spot_id"])
      else
        landmark = SavorLandmark.new
      end
      if(row.key?('add_mode') && row["add_mode"] == "DELETE")
        landmark.destroy
        next
      end

      landmark.id = row["spot_id"]
      landmark.pref_code = row["pref_code"]
      landmark.township_code = row["township_code"]
      landmark.sub_township_code = row["sub_township_code"]
      landmark.coordinate = row["coordinate"]
      landmark.latitude = row["latitude"]
      landmark.longitude = row["longitude"]

      landmark.spot_name_en = row["spot_name_en"]
      landmark.spot_name_zh_hant = row["spot_name_tw"]
      landmark.spot_name_zh_hans = row["spot_name_cn"]
      landmark.spot_name_ja = row["spot_name_jp"]

      landmark.outline_title_en = row["outline_title_en"]
      landmark.outline_title_zh_hant = row["outline_title_tw"]
      landmark.outline_title_zh_hans = row["outline_title_cn"]
      landmark.outline_title_ja = row["outline_title_jp"]

      landmark.outline_en = row["outline_en"]
      landmark.outline_zh_hant = row["outline_tw"]
      landmark.outline_zh_hans = row["outline_cn"]
      landmark.outline_ja = row["outline_jp"]

      landmark.access_en = row["access_en"]
      landmark.access_zh_hant = row["access_tw"]
      landmark.access_zh_hans = row["access_cn"]
      
      landmark.address_en = row["address_en"]
      landmark.address_zh_hant = row["address_tw"]
      landmark.address_zh_hans = row["address_cn"]

      landmark.spot_photo_en = row["spot_photo_en"]
      landmark.spot_photo_zh_hant = row["spot_photo_tw"]
      landmark.spot_photo_zh_hans = row["spot_photo_cn"]
      landmark.save
      
    end
  end
  task :cuisine => :environment do
    csv_text = open("#{path}cuisine_#{fileSuffix}.csv",
      http_basic_authentication: [auth_user, auth_pw])
    CSV.foreach(csv_text,  encoding: "bom|utf-8", headers: true) do |row|
      cuisine = SavorRestaurantCuisineType.new

      cuisine.category_type = row["category_type"]
      cuisine.large_category_code_name = row["large_category_code_name"]
      cuisine.large_category_jp_name = row["large_category_jp_name"]
      cuisine.large_category_code = row["large_category_code"]
      cuisine.small_category_code_name = row["small_category_code_name"]
      cuisine.small_category_code = row["small_category_code"]
      cuisine.small_category_jp_name = row["small_category_jp_name"]
      
      cuisine.large_category_en = row["large_category_en"]
      cuisine.large_category_zh_hant = row["large_category_tw"]
      cuisine.large_category_zh_hans = row["large_category_cn"]

      cuisine.small_category_en = row["small_category_en"]
      cuisine.small_category_zh_hant = row["small_category_tw"]
      cuisine.small_category_zh_hans = row["small_category_cn"]

      cuisine.save
      
    end
  end
  task :restaurants => :environment do
    csv_text = download_to_file("#{path}restaurant_#{fileSuffix}.csv")
    CSV.foreach(csv_text,  encoding: "bom|utf-8", headers: true) do |row|
      if SavorRestaurant.exists?(:restaurant_code => row["restaurant_code"])
        restaurant = SavorRestaurant.find_by_restaurant_code(row["restaurant_code"])
      else
        restaurant = SavorRestaurant.new
        restaurant.restaurant_code = row["restaurant_code"]
      end
      if(row.key?('add_mode') && row["add_mode"] == "DELETE")
        restaurant.destroy
        next
      end
      #base attribtues
      restaurant.jp_name = row["jp_name"]
      restaurant.restaurant_type_class_cd = row["restaurant_type_class_cd"]
      restaurant.restaurant_type_cd = row["restaurant_type_cd"]
      restaurant.tel = row["tel"]
      restaurant.average_price_lunch = row["average_price_lunch"]
      restaurant.average_price_grand = row["average_price_grand"]
      restaurant.coordinate = row["coordinate"]
      restaurant.lat = row["latitude"]
      restaurant.lng = row["longitude"]
      restaurant.internet_available = row["internet_available"]
      restaurant.free_wifi_available = row["free_wifi_available"]
      restaurant.mobile_connectable = row["mobile_connectable"]
      restaurant.separation_of_smoking = row["separation_of_smoking"]
      restaurant.no_smoking = row["no_smoking"]
      restaurant.smoking_available = row["smoking_available"]
      restaurant.course_menu = row["course_menu"]
      restaurant.large_cocktail_selection = row["large_cocktail_selection"]
      restaurant.large_shochu_selection = row["large_shochu_selection"]
      restaurant.large_sake_selection = row["large_sake_selection"]
      restaurant.large_wine_selection = row["large_wine_selection"]
      restaurant.all_you_can_eat = row["all_you_can_eat"]
      restaurant.all_you_can_drink = row["all_you_can_drink"]
      restaurant.lunch_menu = row["lunch_menu"]
      restaurant.take_out = row["take_out"]
      restaurant.coupon = row["coupon"]
      restaurant.small_groups = row["small_groups"]
      restaurant.delivery = row["delivery"]
      restaurant.kids_menu = row["kids_menu"]
      restaurant.special_diet = row["special_diet"]
      restaurant.food_allergy = row["food_allergy"]
      restaurant.vegetarian_menu = row["vegetarian_menu"]
      restaurant.halal_menu = row["halal_menu"]
      restaurant.breakfast = row["breakfast"]
      restaurant.imported_beer = row["imported_beer"]
      restaurant.reservation = row["reservation"]
      restaurant.room_reservation = row["room_reservation"]
      restaurant.storewide_reservation = row["storewide_reservation"]
      restaurant.late_night_service = row["late_night_service"]
      restaurant.child_friendly = row["child_friendly"]
      restaurant.pet_friendly = row["pet_friendly"]
      restaurant.private_room = row["private_room"]
      restaurant.tatami_room = row["tatami_room"]
      restaurant.kotatsu = row["kotatsu"]
      restaurant.parking = row["parking"]
      restaurant.barrier_free = row["barrier_free"]
      restaurant.sommelier = row["sommelier"]
      restaurant.terrace = row["terrace"]
      restaurant.live_show = row["live_show"]
      restaurant.entertainment_facilities = row["entertainment_facilities"]
      restaurant.karaoke = row["karaoke"]
      restaurant.band_playable = row["band_playable"]
      restaurant.tv_projector = row["tv_projector"]
      restaurant.seats_10 = row["seats_10"]
      restaurant.seats_20 = row["seats_20"]
      restaurant.seats_30 = row["seats_30"]
      restaurant.seats_over_30 = row["seats_over_30"]
      restaurant.membership = row["membership"]
      restaurant.jacuzzi = row["jacuzzi"]
      restaurant.vip_room = row["vip_room"]
      restaurant.donated = row["donated"]
      restaurant.donation_box = row["donation_box"]
      restaurant.power_saving = row["power_saving"]
      restaurant.western_cutlery = row["western_cutlery"]
      restaurant.counter_seats = row["counter_seats"]
      restaurant.card_accepted = row["card_accepted"]
      restaurant.card_accept_amex = row["card_accept_amex"]
      restaurant.card_accept_diners = row["card_accept_diners"]
      restaurant.card_accept_master = row["card_accept_master"]
      restaurant.card_accept_visa = row["card_accept_visa"]
      restaurant.card_accept_unionpay = row["card_accept_unionpay"]
      restaurant.electronic_money = row["electronic_money"]
      restaurant.facebook_pages = row["facebook_pages"]
      restaurant.pref_code = row["pref_code"]
      restaurant.township_code = row["township_code"]
      restaurant.sub_township_code = row["sub_township_code"]
      restaurant.cuisine_code_1 = row["cuisine_code_1"]
      restaurant.cuisine_code_2 = row["cuisine_code_2"]
      restaurant.cuisine_code_3 = row["cuisine_code_3"]

      #translations
      restaurant.target_en = row["target_en"]
      restaurant.target_zh_hant = row["target_tw"]
      restaurant.target_zh_hans = row["target_cn"]

      restaurant.information_photo_en = row["information_photo_en"]
      restaurant.information_photo_zh_hant = row["information_photo_tw"]
      restaurant.information_photo_zh_hans = row["information_photo_cn"]

      restaurant.search_result_photo_en = row["search_result_photo_en"]
      restaurant.search_result_photo_zh_hant = row["search_result_photo_tw"]
      restaurant.search_result_photo_zh_hans = row["search_result_photo_cn"]
      
      restaurant.name_en = row["name_en"]
      restaurant.name_zh_hant = row["name_tw"]
      restaurant.name_zh_hans = row["name_cn"]

      restaurant.station_1_en = row["station_1_en"]
      restaurant.station_1_zh_hant = row["station_1_tw"]
      restaurant.station_1_zh_hans = row["station_1_cn"]

      restaurant.station_2_en = row["station_2_en"]
      restaurant.station_2_zh_hant = row["station_2_tw"]
      restaurant.station_2_zh_hans = row["station_2_cn"]

      restaurant.directions_en = row["directions_en"]
      restaurant.directions_zh_hant = row["directions_tw"]
      restaurant.directions_zh_hans = row["directions_cn"]

      restaurant.catch_copy_title_en = row["catch_copy_title_en"]
      restaurant.catch_copy_title_zh_hant = row["catch_copy_title_tw"]
      restaurant.catch_copy_title_zh_hans = row["catch_copy_title_cn"]

      restaurant.catch_copy_en = row["catch_copy_en"]
      restaurant.catch_copy_zh_hant = row["catch_copy_tw"]
      restaurant.catch_copy_zh_hans = row["catch_copy_cn"]

      restaurant.open_en = row["open_en"]
      restaurant.open_zh_hant = row["open_tw"]
      restaurant.open_zh_hans = row["open_cn"]

      restaurant.holiday_en = row["holiday_en"]
      restaurant.holiday_zh_hant = row["holiday_tw"]
      restaurant.holiday_zh_hans = row["holiday_cn"]

      restaurant.address_en = row["address_en"]
      restaurant.address_zh_hant = row["address_tw"]
      restaurant.address_zh_hans = row["address_cn"]

      restaurant.menu_en = row["menu_en"]
      restaurant.menu_zh_hant = row["menu_tw"]
      restaurant.menu_zh_hans = row["menu_cn"]
      
      restaurant.languages_available_en = row["languages_available_en"]
      restaurant.languages_available_zh_hant = row["languages_available_tw"]
      restaurant.languages_available_zh_hans = row["languages_available_cn"]

      restaurant.reserve_en = row["reserve_form_en"]
      restaurant.reserve_zh_hant = row["reserve_form_tw"]
      restaurant.reserve_zh_hans = row["reserve_form_cn"]
      #save
      restaurant.save
    end
  
  end
  def download_to_file(uri)
    auth_user = "tsunagu_Japan"
    auth_pw = "Jx6mCgzhUm"
    stream = open(uri, 
      http_basic_authentication: [auth_user, auth_pw])
    return stream if stream.respond_to?(:path) # Already file-like
  
    Tempfile.new.tap do |file|
      file.binmode
      IO.copy_stream(stream, file)
      stream.close
      file.rewind
    end
  end
end