class CreateHotelDetails < ActiveRecord::Migration[6.0] 
  def change
    create_table :hotel_details do |t|
      t.string :address
      t.string :url
      t.string :description
      t.integer :service, default: 0
      t.timestamps null: false
      t.string :long
      t.string :lat
      t.string  :currency
      t.string  :min_rate
    end
  end
end
