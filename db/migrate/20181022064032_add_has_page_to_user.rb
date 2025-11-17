class AddHasPageToUser < ActiveRecord::Migration[6.0] 
  def change
    add_column :users, :has_page, :integer, default: 0
  end
end
