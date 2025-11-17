class AddLocationToWeather < ActiveRecord::Migration[6.0] 
  def change
    add_column :weather, :location, :string
  end
end
