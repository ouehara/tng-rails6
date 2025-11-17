class LangUpdatedAtToArticles < ActiveRecord::Migration[6.0] 
  def change
    add_column :articles, :lang_updated_at, :jsonb
  end
end
 