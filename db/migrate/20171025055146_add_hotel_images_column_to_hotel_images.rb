class AddHotelImagesColumnToHotelImages < ActiveRecord::Migration[6.0] 
  def change
    add_attachment :hotel_images, :image
  end
end
