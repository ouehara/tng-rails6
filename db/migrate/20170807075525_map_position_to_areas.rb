class MapPositionToAreas < ActiveRecord::Migration[6.0] 
  def change
    add_column :areas, :map_position, :integer
  end
end
