class AddIndexToSavorCuisines < ActiveRecord::Migration[6.0] 
  def change 
    add_index :savor_restaurant_cuisine_type_translations, :large_category, :name => "large_cat_index"
  end
end
