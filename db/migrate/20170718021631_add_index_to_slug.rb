class AddIndexToSlug < ActiveRecord::Migration[6.0] 
  def change
    add_index :article_translations, :slug
  end
end
