class AddAncestryToAreas < ActiveRecord::Migration[6.0] 
  def change
    add_column :areas, :ancestry, :string
    add_index :areas, :ancestry
  end
end
