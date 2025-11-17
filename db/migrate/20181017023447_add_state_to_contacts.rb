class AddStateToContacts < ActiveRecord::Migration[6.0] 
  def change
    add_column :contacts, :state, :integer, default: 0
  end
end
