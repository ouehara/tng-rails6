class AddCounterCacheToTags < ActiveRecord::Migration[6.0] 
  def change
    add_column :tags, :article_count, :integer
  end
end
