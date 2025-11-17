namespace :import_agoda do
  task :create_hotel => :environment do
    filename = "lib/tasks/agoda/E342B777-64FD-4A49-9C9F-FEF4BA635863_EN.csv"
    CSV.foreach(filename, {:headers => true}) do |row|
      r = row.to_hash
      if(r["country"] == "Japan" )
        hotel = Hotel.find_or_create_by(name: r["hotel_name"])
        hotel_details = HotelDetail.create()
        hotel_details.hotel = hotel
        hotel_details.address = r["addressline1"]
        hotel_details.url = "http://www.agoda.com#{r["url"]}?cid=1755750"
        hotel_details.image = r["photo1"]
        hotel_details.description = r["overview"]
        hotel_details.long = r["longitude"]
        hotel_details.lat = r["latitude"]
        hotel_details.currency = r["rates_currency"]
        hotel_details.min_rate = r["rates_from"]
        hotel_details.service = 1
        hotel_details.save
        hotel.save
      end
    end
  end
end