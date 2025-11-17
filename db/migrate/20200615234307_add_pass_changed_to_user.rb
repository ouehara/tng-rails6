class AddPassChangedToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :pass_changed, :boolean, default: true
  end
end
