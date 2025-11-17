class AddForeignKeyToRestaurantMenu < ActiveRecord::Migration[6.0] 
  def change
    remove_column :savor_menus, :savor_restaurant_id
    add_column :savor_menus, :restaurant_code, :string, index: true, foreign_key: true
  end
end
