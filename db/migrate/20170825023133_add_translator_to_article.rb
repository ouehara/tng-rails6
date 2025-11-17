class AddTranslatorToArticle < ActiveRecord::Migration[6.0] 
  def change
    create_table :article_translators do |t| 
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :article, index: true, foreign_key: true
      t.string :lang
    end
  end
end