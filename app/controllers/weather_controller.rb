class WeatherController < ApplicationController
  def search
    @weather = Weather.cached_weather(search_params[:query])
    #if @weather.blank?
    #  @weather = Weather.new
    #  @weather.location = search_params[:query]
    #  update_weather
      
    #end
    #nextUpdate = @weather.updated_at.to_time
    #if(Time.now > nextUpdate + 1.hours)
    #  update_weather
    #end

    render json: @weather
  end
  def update_weather
    @client = OpenWeatherAdapter.new
    res = @client.find(search_params[:query])
    @weather.degrees = res['main']['temp'].round
    @weather.description = res['weather'][0]['description']
    @weather.save 
  end


  private
  def search_params
    params.permit(:query)
  end

  

end