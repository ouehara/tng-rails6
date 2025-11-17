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

class SavorRestaurantCuisineType < ActiveRecord::Base
  translates :large_category, :small_category
  globalize_accessors :locales => ["en", "zh-hant", "zh-hans", "ja", "th","ko","vi"],
  :attributes => [:large_category,:small_category]
end
