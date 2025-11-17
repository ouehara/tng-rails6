class AddFieldsToRestaurants < ActiveRecord::Migration[6.0] 
  def change 
    add_column :savor_restaurants, :pref_code, :string
    add_column :savor_restaurants, :township_code, :string
    add_column :savor_restaurants, :sub_township_code, :string
  end
end
