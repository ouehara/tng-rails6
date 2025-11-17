class CreatePickupHotelLp < ActiveRecord::Migration[6.0] 
  def change
    create_table :pickup_hotel_lps do |t|
      t.belongs_to :hotel_landingpages, index: true
      t.integer  :position, default: 0
      t.string :lang, index: true
    end
  end
end
