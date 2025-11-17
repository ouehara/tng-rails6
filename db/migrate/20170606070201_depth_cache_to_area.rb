class DepthCacheToArea < ActiveRecord::Migration[6.0] 
  def change
    add_column :areas, :names_depth_cache, :string
  end
end
