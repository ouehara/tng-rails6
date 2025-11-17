class AddTitleImageToArticle < ActiveRecord::Migration[6.0] 
  def self.up
    add_attachment :articles, :title_image
  end
  def self.down
    remove_attachment :articles, :title_image
  end
end
