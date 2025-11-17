class AddAdToRestaurantSearch < ActiveRecord::Migration[6.0] 
  def change
    reversible do |dir|
      dir.up do
        SavorRestaurant.add_translation_fields! ad: :integer
      end

      dir.down do
        remove_column :savor_restaurant_translations, :ad
      end
    end
    
  end
end
