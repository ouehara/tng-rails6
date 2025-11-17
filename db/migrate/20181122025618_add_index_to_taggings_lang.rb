class AddIndexToTaggingsLang < ActiveRecord::Migration[6.0] 
  def change
    add_index :taggings, :lang
  end
end
