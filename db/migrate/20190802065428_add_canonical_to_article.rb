class AddCanonicalToArticle < ActiveRecord::Migration[6.0] 
  def change
    Article.add_translation_fields! canonical: :text
  end
end
