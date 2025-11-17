class AddAreaToArticles < ActiveRecord::Migration[6.0] 
  def change
    add_reference :articles, :area, index: true, foreign_key: true
  end
end
