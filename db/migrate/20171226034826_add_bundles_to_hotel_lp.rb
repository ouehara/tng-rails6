class AddBundlesToHotelLp < ActiveRecord::Migration[6.0] 
  def change
    # Add translation fields manually for ECS compatibility
    if table_exists?(:hotel_landingpage_translations)
      add_column :hotel_landingpage_translations, :official_text, :boolean unless column_exists?(:hotel_landingpage_translations, :official_text)
      add_column :hotel_landingpage_translations, :recommend_text, :boolean unless column_exists?(:hotel_landingpage_translations, :recommend_text)
    end
  end
end
 