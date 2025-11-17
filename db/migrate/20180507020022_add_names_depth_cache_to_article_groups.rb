class AddNamesDepthCacheToArticleGroups < ActiveRecord::Migration[6.0] 
  def change
    add_column :article_groups, :names_depth_cache, :string
  end
end
