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

require 'rails_helper'

RSpec.describe SavorCoupon, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
