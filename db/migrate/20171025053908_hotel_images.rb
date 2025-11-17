class HotelImages < ActiveRecord::Migration[6.0] 
  def change
    create_table :hotel_images do |t|
      t.belongs_to :hotel_landingpages, index: true
    end
  end
end
