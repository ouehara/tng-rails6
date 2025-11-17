class AddNamesDepthCacheToCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :names_depth_cache, :string
  end
end
