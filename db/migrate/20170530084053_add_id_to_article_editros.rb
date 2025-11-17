class AddIdToArticleEditros < ActiveRecord::Migration[6.0] 
  def change
    add_column :article_editors, :id, :primary_key
  end
end
