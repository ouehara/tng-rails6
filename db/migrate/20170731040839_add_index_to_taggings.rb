class AddIndexToTaggings < ActiveRecord::Migration[6.0] 
  def change
    add_index :taggings, [:article_id, :lang]
  end
end
