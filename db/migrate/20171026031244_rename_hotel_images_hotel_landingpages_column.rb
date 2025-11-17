class RenameHotelImagesHotelLandingpagesColumn < ActiveRecord::Migration[6.0] 
  def change
    rename_column :hotel_images, :hotel_landingpages_id, :hotel_landingpage_id    
  end
end
