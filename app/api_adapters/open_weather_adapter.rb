class OpenWeatherAdapter
  include HTTParty  
  base_uri "http://api.openweathermap.org/data/2.5"
  headers  "Authorization" => "Bearer #{ENV['TNG_PIXTA_TOKEN']}"
  
  # id, name, url, tags
  def find(place)
    #http://api.openweathermap.org/data/2.5/weather?q=" + this.props.curArea + ",jp&units=metric&APPID=06c1a9bb61e6961f41a3b8fabf3d9216
    self.class.get("/weather", :query => {q: place+",jp",units: "metric", "APPID": "06c1a9bb61e6961f41a3b8fabf3d9216"})
  end
end