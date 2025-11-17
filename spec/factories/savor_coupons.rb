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

FactoryBot.define do
  factory :savor_coupon do
    
  end
end
