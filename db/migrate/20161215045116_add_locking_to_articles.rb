class AddLockingToArticles < ActiveRecord::Migration[6.0] 
  def change
    add_column :articles, :lock_version, :integer
  end
end
