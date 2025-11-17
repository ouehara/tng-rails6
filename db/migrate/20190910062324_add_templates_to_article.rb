class AddTemplatesToArticle < ActiveRecord::Migration[6.0] 
  def change
    add_column :articles, :unlist, :boolean, :default => false
    add_column :articles, :template, :integer, :default => 1
  end
end
