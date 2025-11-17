class AddDispTitleToArticles < ActiveRecord::Migration[6.0] 
  def change
    add_column :articles, :disp_title, :jsonb
  end
end
