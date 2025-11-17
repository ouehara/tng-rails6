class AddPublishToHotelLandingpages < ActiveRecord::Migration[6.0] 
  def change
    # Add translation field manually for ECS compatibility
    if table_exists?(:hotel_landingpage_translations)
      add_column :hotel_landingpage_translations, :published, :boolean unless column_exists?(:hotel_landingpage_translations, :published)
    end
  end
end
