class AddForeignKeyToRelatedArticle < ActiveRecord::Migration[6.0] 
  def change
    add_foreign_key :related_articles, :articles, column: :article_id, primary_key: :id
    add_foreign_key :related_articles, :articles, column: :related_article_id, primary_key: :id
  end
end
