class AddPositionToHotelLandingpage < ActiveRecord::Migration[6.0] 
  def change
    add_column :hotel_landingpages, :position, :integer, :null => false, :default => 1
    add_index :hotel_landingpages, [:position]
  end
end
