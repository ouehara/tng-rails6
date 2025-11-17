json.array!(@admin_hotel_landingpages) do |admin_hotel_landingpage|
  json.extract! admin_hotel_landingpage, :id
  json.url admin_hotel_landingpage_url(admin_hotel_landingpage, format: :json)
end
