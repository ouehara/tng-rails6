class AddIndexToSavorRestaurants < ActiveRecord::Migration[6.0] 
  def change
    add_index :savor_restaurant_translations, :name
    add_index :savor_restaurants, :pref_code
    add_index :savor_restaurants, :township_code
    add_index :savor_restaurants, :sub_township_code
    add_index :savor_restaurants, [:cuisine_code_1, :cuisine_code_2,:cuisine_code_3], :name => 'cuisine_combined_index'
  end
end
