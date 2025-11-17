class RemoveSeoTitle < ActiveRecord::Migration[6.0] 
  def change
    remove_column :categories, :seo_title
  end
end
