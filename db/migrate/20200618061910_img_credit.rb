class ImgCredit < ActiveRecord::Migration[6.0]
  def change
      remove_column :hotel_landingpages, :img_src
      HotelLandingpage.add_translation_fields! img_src: :text
  end
end
