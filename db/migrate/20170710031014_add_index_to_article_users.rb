class AddIndexToArticleUsers < ActiveRecord::Migration[6.0] 
  def change
    add_index :article_users, [:article_id, :lang], unique: true if !index_exists?(:article_users, [:article_id, :lang])
  end
end
