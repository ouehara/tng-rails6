# == Schema Information
#
# Table name: savor_coupons
#
#  id                  :integer          not null, primary key
#  savor_restaurant_id :integer
#  coupon_code         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class SavorCoupon < ActiveRecord::Base
  belongs_to :savor_restaurant, foreign_key: :restaurant_code
  translates :target, :coupon_title, :coupon_description,
  :coupon_available_from, :coupon_available_to, 
  :coupon_publish_from, :coupon_publish_to

  globalize_accessors :locales => ["en", "zh-hant", "zh-hans", "ja", "th","ko","vi"],
  :attributes => [:target,:coupon_title,:coupon_description,:coupon_available_from,
  :coupon_available_to, :coupon_publish_from,:coupon_publish_to]
end
