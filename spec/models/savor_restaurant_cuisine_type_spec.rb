# == Schema Information
#
# Table name: savor_restaurant_cuisine_types
#
#  id                       :integer          not null, primary key
#  category_type            :string
#  large_category_code_name :string
#  large_category_jp_name   :string
#  small_category_code_name :string
#  small_category_code      :string
#  small_category_jp_name   :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'rails_helper'

RSpec.describe SavorRestaurantCuisineType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
