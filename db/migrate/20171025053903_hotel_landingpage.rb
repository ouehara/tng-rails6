class HotelLandingpage < ActiveRecord::Migration[6.0] 
  def change
    create_table :hotel_landingpages do |t|
      t.belongs_to :areas, index: true
    end
    
  end
end
