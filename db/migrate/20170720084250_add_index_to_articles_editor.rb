class AddIndexToArticlesEditor < ActiveRecord::Migration[6.0]
  def change
    unless index_exists?(:article_editors, :articles_id)
      add_index :article_editors, :articles_id
    end
  end
end 
