class AddUniqueToHotelName < ActiveRecord::Migration[6.0] 
  def change
    
    add_index :hotels, :name, :unique => true

  end
end
