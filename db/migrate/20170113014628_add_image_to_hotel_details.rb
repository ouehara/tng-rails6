class AddImageToHotelDetails < ActiveRecord::Migration[6.0] 
  def change
    add_column :hotel_details, :image, :string
  end
end
