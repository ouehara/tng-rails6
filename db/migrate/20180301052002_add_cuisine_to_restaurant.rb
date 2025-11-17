class AddCuisineToRestaurant < ActiveRecord::Migration[6.0] 
  def change
    add_column :savor_restaurants, :cuisine_code_1, :string
    add_column :savor_restaurants, :cuisine_code_2, :string
    add_column :savor_restaurants, :cuisine_code_3, :string
  end
end
