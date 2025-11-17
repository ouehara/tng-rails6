class AddForeginKeyToSavorPhoto < ActiveRecord::Migration[6.0] 
  def change
    remove_column :savor_image_data, :savor_restaurant_id
    add_column :savor_image_data, :restaurant_code, :string, index: true, foreign_key: true
  end
end
