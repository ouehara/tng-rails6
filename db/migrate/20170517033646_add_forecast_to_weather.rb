class AddForecastToWeather < ActiveRecord::Migration[6.0] 
  def change
     add_column :weathers, :forecast, :jsonb
  end
end
