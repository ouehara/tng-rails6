class AddForeignKeyToCoupons < ActiveRecord::Migration[6.0] 
  def change
    remove_column :savor_coupons, :savor_restaurant_id
    add_column :savor_coupons, :restaurant_code, :string, index: true, foreign_key: true
  end
end
