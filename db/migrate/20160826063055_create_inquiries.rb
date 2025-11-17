class CreateInquiries < ActiveRecord::Migration[6.0] 
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :title
      t.text :content

      t.timestamps null: false
    end
  end
end
