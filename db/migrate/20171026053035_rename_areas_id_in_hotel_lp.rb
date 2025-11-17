class RenameAreasIdInHotelLp < ActiveRecord::Migration[6.0] 
  def change
    rename_column :hotel_landingpages, :areas_id, :area_id    
  end
end
