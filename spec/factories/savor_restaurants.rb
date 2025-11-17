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

FactoryBot.define do
  factory :savor_restaurant do
    
  end
end
