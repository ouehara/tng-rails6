class AddDefaultValueToRestaurantAds < ActiveRecord::Migration[6.0] 
  def change
    change_column_default :savor_restaurant_translations, :ad, 0


  end
end
