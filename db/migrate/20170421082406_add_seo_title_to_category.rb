class AddSeoTitleToCategory < ActiveRecord::Migration[6.0] 
  def change
    add_column :categories, :seo_title, :string
  end
end
