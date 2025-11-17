class AddHotelidToHotelDetails < ActiveRecord::Migration[6.0] 
  def change
    add_reference :hotel_details, :hotel, index: true, foreign_key: true
  end
end
