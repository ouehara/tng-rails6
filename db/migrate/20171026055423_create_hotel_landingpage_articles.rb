class CreateHotelLandingpageArticles < ActiveRecord::Migration[6.0] 
  def change
    create_table :hotel_landingpage_articles do |t|
      t.belongs_to :hotel_landingpage, index: true, foreign_key: true
      t.belongs_to :article, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
