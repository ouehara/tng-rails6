class AddLargeCategoryCodeToCuisine < ActiveRecord::Migration[6.0] 
  def change
    add_column :savor_restaurant_cuisine_types, :large_category_code, :string
  end
end
