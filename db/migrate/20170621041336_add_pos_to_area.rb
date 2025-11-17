class AddPosToArea < ActiveRecord::Migration[6.0] 
  def change 
    add_column :areas, :pos, :integer
  end
end
