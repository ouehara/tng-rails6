class AddIndexToArticleTranslations < ActiveRecord::Migration[6.0] 
  def change
    add_index :article_translations, [:slug, :locale]
  end
end
