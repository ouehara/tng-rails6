class PocketsWeatherAdapter
  include HTTParty  
  base_uri "http://s072.b-10.net/v1/f94a36e6-9cc8a8de-1ece3253-c588d3c9"
  # http://{$serverId}.b-10.net/v1/{$userDirectory}/weather/daily/1/?area={$areaCode}&date={$dateCode}
  # id, name, url, tags
  def find(place, date)
    self.class.get("/weather/daily/1/", :query => {area: place, date: date})
  end

  def forecast(place)
    self.class.get("/weather/daily/1/", :query => {area: place, date: "7days"})
  end
  
end