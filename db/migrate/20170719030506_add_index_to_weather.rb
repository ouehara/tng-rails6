class AddIndexToWeather < ActiveRecord::Migration[6.0] 
  def change
    add_index :weathers, :location
  end
end 
