# == Schema Information
#
# Table name: savor_restaurants
#
#  id                       :integer          not null, primary key
#  restaurant_code          :string
#  jp_name                  :string
#  restaurant_type_class_cd :string
#  restaurant_type_cd       :string
#  tel                      :string
#  average_price_lunch      :integer
#  average_price_grand      :integer
#  coordinate               :string
#  lat                      :decimal(, )
#  lng                      :decimal(, )
#  internet_available       :integer
#  free_wifi_available      :integer
#  mobile_connectable       :integer
#  separation_of_smoking    :integer
#  no_smoking               :integer
#  smoking_available        :integer
#  course_menu              :integer
#  large_cocktail_selection :integer
#  large_shochu_selection   :integer
#  large_sake_selection     :integer
#  large_wine_selection     :integer
#  all_you_can_eat          :integer
#  all_you_can_drink        :integer
#  lunch_menu               :integer
#  take_out                 :integer
#  coupon                   :integer
#  small_groups             :integer
#  delivery                 :integer
#  kids_menu                :integer
#  special_diet             :integer
#  food_allergy             :integer
#  vegetarian_menu          :integer
#  halal_menu               :integer
#  breakfast                :integer
#  imported_beer            :integer
#  reservation              :integer
#  room_reservation         :integer
#  storewide_reservation    :integer
#  late_night_service       :integer
#  child_friendly           :integer
#  pet_friendly             :integer
#  private_room             :integer
#  tatami_room              :integer
#  kotatsu                  :integer
#  parking                  :integer
#  barrier_free             :integer
#  sommelier                :integer
#  terrace                  :integer
#  live_show                :integer
#  entertainment_facilities :integer
#  karaoke                  :integer
#  band_playable            :integer
#  tv_projector             :integer
#  seats_10                 :integer
#  seats_20                 :integer
#  seats_30                 :integer
#  seats_over_30            :integer
#  membership               :integer
#  jacuzzi                  :integer
#  vip_room                 :integer
#  donated                  :integer
#  donation_box             :integer
#  power_saving             :integer
#  western_cutlery          :integer
#  counter_seats            :integer
#  card_accepted            :integer
#  card_accept_amex         :integer
#  card_accept_diners       :integer
#  card_accept_master       :integer
#  card_accept_visa         :integer
#  card_accept_unionpay     :integer
#  electronic_money         :integer
#  facebook_pages           :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pref_code                :string
#  township_code            :string
#  sub_township_code        :string
#

class SavorRestaurant < ActiveRecord::Base
  include Filterable
  has_many :savor_coupons, foreign_key: :restaurant_code
  has_many :savor_image_data, class_name: "SavorImageData", primary_key: :restaurant_code,foreign_key: :restaurant_code
  translates :target ,:information_photo, :search_result_photo,
  :name, :station_1, :station_2, :directions, :catch_copy_title,
  :catch_copy, :open, :holiday, :address, :menu, :languages_available, :ad, :reserve

  globalize_accessors :locales => ["en", "zh-hant", "zh-hans", "ja", "th","ko","vi"],
  :attributes => [:target,
  :information_photo,:search_result_photo,:name, :station_1,
  :station_2, :directions, :catch_copy_title,:catch_copy,:open,
  :holiday, :address, :menu, :languages_available, :reserve]

  scope :cuisine_id, -> (id) {
    where('restaurant_type_class_cd=:query', query: "#{id}")
  }

  scope :sub_cuisine_id, -> (id) {
    where('cuisine_code_1=:query or cuisine_code_2 = :query or cuisine_code_3 = :query', query: "#{id}")
  }

  scope :no_smoking, -> (val) {where(:no_smoking => val)}
  scope :menu, -> (val) {where(:menu => val)}
  scope :languages_available, ->(val) {where(:languages_available => val)}
  scope :late_night_service, ->(val) {where(:late_night_service => val)}
  scope :special_diet, ->(val) {where(:special_diet => val)}
  scope :western_cutlery, ->(val) {where(:western_cutlery => val)}
  scope :lunch_menu, ->(val) {where(:lunch_menu => val)}
  scope :free_wifi_available, ->(val) {where(:free_wifi_available => val)}
  scope :master_card, ->(val) {where(:card_accept_master => val)}
  scope :visa, ->(val) {where(:card_accept_visa => val)}
  scope :american_express, ->(val) {where(:card_accept_amex => val)}
  scope :diners_club, ->(val) {where(:card_accept_diners => val)}
  scope :coupons, ->(val) {where(:coupon => val)}
  def search_image
    img_name = ""
    if (self.search_result_photo == "" || self.search_result_photo.nil?)
      img_name = self.savor_image_data.first.photo.gsub '740x555', '198x148' unless self.savor_image_data.first.nil?
      return img_name
    else
      img_name = self.search_result_photo.gsub '740x555', '198x148'
      # return "https://savorjapan.com#{img_name}"
      return img_name
    end
  end

  def savor_url
    prefix = {"zh-hant" => "tw.", "zh-hans" => "cn.", "en" => "", "th"=> ""}
    return "https://#{prefix[I18n.locale.to_s]}savorjapan.com/#{self.restaurant_code}/"
  end

  def cuisine_1
    cusine = SavorRestaurantCuisineType.with_translations(I18n.locale).where(:small_category_code => self.cuisine_code_1)
    cusine.first.large_category+" / "+ cusine.first.small_category unless cusine.first.nil?
  end
  def cuisine_2
    cusine = SavorRestaurantCuisineType.where(:small_category_code => self.cuisine_code_2)
    ", "+cusine.first.large_category+" / "+cusine.first.small_category unless cusine.first.nil?
  end
  def cuisine_3
    cusine = SavorRestaurantCuisineType.where(:small_category_code => self.cuisine_code_3)
    ", "+cusine.first.large_category+" / "+cusine.first.small_category unless cusine.first.nil?
  end

  def loc
    SavorLocation.find_by_township_code(self.township_code)
  end


  def sav_img
    #if self.search_image != "" && !self.search_image.nil?
    #  return "b"
    #end
    return SavorImageData.where(:restaurant_code => self.restaurant_code).order("search_result_flag").first

  end

end
