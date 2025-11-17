class CreateSavorRestaurantCuisineTypes < ActiveRecord::Migration[6.0] 
  def change
    create_table :savor_restaurant_cuisine_types do |t|
      t.string :category_type
      t.string :large_category_code_name
      t.string :large_category_jp_name
      t.string :small_category_code_name
      t.string :small_category_code
      t.string :small_category_jp_name
      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        SavorRestaurantCuisineType.create_translation_table! :large_category => :text,
        :small_category => :text
      end
    end
  end
end
