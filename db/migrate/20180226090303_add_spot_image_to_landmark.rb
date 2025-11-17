class AddSpotImageToLandmark < ActiveRecord::Migration[6.0] 
  def change
    SavorLandmark.add_translation_fields! spot_photo: :string
  end
end
