class RenameWeatherToWeathers < ActiveRecord::Migration[6.0] 
  def change
    rename_table :weather, :weathers
  end
end
