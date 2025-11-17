# == Schema Information
#
# Table name: savor_image_data
#
#  id                  :integer          not null, primary key
#  savor_restaurant_id :integer
#  lang                :string
#  photo               :string
#  photo_genre         :string
#  photo_caption       :string
#  information_flag    :string
#  search_result_flag  :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class SavorImageData < ActiveRecord::Base
  belongs_to :savor_restaurant, foreign_key: :restaurant_code
end
