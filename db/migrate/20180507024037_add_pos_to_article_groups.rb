class AddPosToArticleGroups < ActiveRecord::Migration[6.0] 
  def change
    add_column :article_groups, :pos, :integer
  end
end
