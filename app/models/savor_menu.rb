# == Schema Information
#
# Table name: savor_menus
#
#  id                  :integer          not null, primary key
#  savor_restaurant_id :integer
#  menu_code           :string
#  menu_type           :integer
#  carry_page          :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class SavorMenu < ActiveRecord::Base
  belongs_to :savor_restaurant,foreign_key: :restaurant_code
  translates :target, :menu_name, :menu_caption, :menu_price, :menu_photo
  globalize_accessors :locales => ["en", "zh-hant", "zh-hans", "ja", "th","ko","vi"],
  :attributes => [:target,:menu_name,:menu_caption,:menu_price,:menu_photo]
end
