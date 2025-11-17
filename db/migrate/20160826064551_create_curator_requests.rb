class CreateCuratorRequests < ActiveRecord::Migration[6.0] 
  def change
    create_table :curator_requests do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.datetime :rejected_at
      t.datetime :accepted_at
      t.text :message

      t.timestamps null: false
    end
  end
end
