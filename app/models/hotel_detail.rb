# == Schema Information
#
# Table name: hotel_details
#
#  id          :integer          not null, primary key
#  address     :string
#  url         :string
#  description :string
#  service     :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  long        :string
#  lat         :string
#  currency    :string
#  min_rate    :string
#  hotel_id    :integer
#  image       :string
#

class HotelDetail < ActiveRecord::Base
  belongs_to :hotel
end
