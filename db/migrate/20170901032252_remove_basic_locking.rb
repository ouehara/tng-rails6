class RemoveBasicLocking < ActiveRecord::Migration[6.0] 
  def change
    remove_column :articles, :lock_version
  end
end
