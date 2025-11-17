class ChangeArticleTranslated < ActiveRecord::Migration[6.0] 
  def change
    rename_column :articles, :translated, :is_translated
  end
end
