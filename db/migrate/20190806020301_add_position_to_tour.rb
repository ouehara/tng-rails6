class AddPositionToTour < ActiveRecord::Migration[6.0] 
  def change
    add_column :tours, :position, :integer, :null => false, :default=>0
  end
end
