class RenameSortInSidebarad < ActiveRecord::Migration[6.0] 
  def change
    add_column :sidebar_ads, :position, :integer, default: 0
  end
end
