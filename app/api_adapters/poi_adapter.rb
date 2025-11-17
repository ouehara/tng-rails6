class PoiAdapter
  include HTTParty  
  base_uri "https://b37ewe94sb.execute-api.ap-northeast-1.amazonaws.com/latest"
  def find(place)
    JSON.parse self.class.get("/find/"+place).body
  end

  def search(searchText)
    self.class.get("/search/"+searchText)
  end
  
end