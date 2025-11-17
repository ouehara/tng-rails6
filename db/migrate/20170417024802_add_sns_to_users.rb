class AddSnsToUsers < ActiveRecord::Migration[6.0] 
  def change
    add_column :users, :facebook, :string
    add_column :users, :instagram, :string
    add_column :users, :twitter, :string
    add_column :users, :google, :string
    add_column :users, :pintrest, :string
  end
end
