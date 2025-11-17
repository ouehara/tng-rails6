namespace :weather do
  task :update_weather => :environment do
    if ENV["RAILS_ENV"] == "production"
      Weather.delete_all
      cl = PocketsWeatherAdapter.new
      ActiveRecord::Base.connection_pool.with_connection do
        Area.all.each do |area|
          next if (area["area_code"] == nil)
          forecast = cl.forecast(area["area_code"]).parsed_response
          w = Weather.new
          w.location = area.name
          w.forecast = forecast
          w.save
        end
      end
    end
  end
end