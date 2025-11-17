class AddPositionToCategory < ActiveRecord::Migration[6.0] 
  def change
    add_column :categories, :position, :integer
    Category.order(:updated_at).each.with_index(1) do |item, index|
      item.update_column :position, index
    end
    add_index :categories, :position
  end
end
