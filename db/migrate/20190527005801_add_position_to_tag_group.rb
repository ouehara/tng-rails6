class AddPositionToTagGroup < ActiveRecord::Migration[6.0] 
  def change
    add_column :tag_groups, :position, :integer
  end
end
