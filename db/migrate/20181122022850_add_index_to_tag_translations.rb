class AddIndexToTagTranslations < ActiveRecord::Migration[6.0] 
  def change
    add_index :tag_translations, :name
  end
end
