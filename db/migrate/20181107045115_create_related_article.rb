class CreateRelatedArticle < ActiveRecord::Migration[6.0] 
  def change
    create_table :related_articles do |t|
      t.references :article
      t.references :related_article
    end
  end
end
