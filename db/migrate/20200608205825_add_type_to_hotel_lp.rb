class AddTypeToHotelLp < ActiveRecord::Migration[6.0]
  def change
    add_column :hotel_landingpages, :category, :integer, default: 1
  end
end
