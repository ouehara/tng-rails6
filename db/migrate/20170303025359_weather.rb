class Weather < ActiveRecord::Migration[6.0] 
  def change
    create_table :weather do |t|
      t.integer :degrees
      t.string :description
      t.timestamps null: false
    end
  end
end
