class AddReserveToSavorRestaurants < ActiveRecord::Migration[6.0] 
  def change
    SavorRestaurant.add_translation_fields! reserve: :text
  end
end
