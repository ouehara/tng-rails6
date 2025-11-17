class CreateHotelFeatures < ActiveRecord::Migration[6.0] 
  def change
    create_table :hotel_features do |t|
      t.belongs_to :hotel_landingpage, index: true, foreign_key: true
      t.integer :feature, index: true
    end
  end
end
