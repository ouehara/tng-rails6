# == Schema Information
#
# Table name: pickup_hotel_lps
#
#  id                    :integer          not null, primary key
#  hotel_landingpages_id :integer
#  position              :integer          default(0)
#  lang                  :string
#

class PickupHotelLp < ActiveRecord::Base
  belongs_to :hotel_landingpages
  enum position: { left: 1, middle: 2, right: 3 }

  def self.update_or_create_by(args, attributes)
    obj = self.find_or_create_by(args)
    obj.update(attributes)
    return obj
  end

end
