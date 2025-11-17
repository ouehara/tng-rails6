class CreateHotelLandingpageTranslation < ActiveRecord::Migration[6.0] 
  def change
    # Create translation table manually for ECS compatibility
    unless table_exists?(:hotel_landingpage_translations)
      create_table :hotel_landingpage_translations do |t|
        t.references :hotel_landingpage, null: false, foreign_key: true
        t.string :locale, null: false
        t.string :name
        t.text :description
        t.string :price
        t.string :summary
        t.string :url
        t.string :address
        t.timestamps null: false
      end
      
      add_index :hotel_landingpage_translations, :locale
      add_index :hotel_landingpage_translations, [:hotel_landingpage_id, :locale], 
                unique: true, name: 'index_hotel_lp_translations_on_lp_id_and_locale'
    end
  end
end
