class AddImgSrcToHotelLp < ActiveRecord::Migration[6.0]
  def change
    add_column :hotel_landingpages, :img_src, :string
  end
end
