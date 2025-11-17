class AddColumnAgreementToContacts < ActiveRecord::Migration[6.0] 
  def change
    add_column :contacts, :agreement, :boolean, default: false
  end
end
