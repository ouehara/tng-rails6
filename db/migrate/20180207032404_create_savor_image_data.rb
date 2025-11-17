class CreateSavorImageData < ActiveRecord::Migration[6.0] 
  def change
    create_table :savor_image_data do |t|
      t.belongs_to :savor_restaurant, index: true
      t.string :lang
      t.string :photo
      t.string :photo_genre
      t.string :photo_caption
      t.string :information_flag
      t.string :search_result_flag
      t.timestamps null: false
    end
  end
end
