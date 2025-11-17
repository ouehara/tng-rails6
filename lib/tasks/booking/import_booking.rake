require 'csv'
class StrictTsv
  attr_reader :filepath
  def initialize(filepath)
    @filepath = filepath
  end

  def parse
    open(filepath) do |f|
      headers = f.gets.strip.split("\t")
      f.each do |line|
        fields = Hash[headers.zip(line.split("\t"))]
        yield fields
      end
    end
  end
end

namespace :import_booking do
  task :create_hotel, [:num] => :environment do |t, args|
    filename = "lib/tasks/booking/8ANdTVsOIl70v7JOZ3Acw_Asia_#{args['num']}.tsv"
    #CSV.foreach(filename, {:headers => true, :col_sep => "\t", :quote_char => "\x00"}) do |row|
    StrictTsv.new(filename).parse do |row|
      r = row.to_hash
      hotel = Hotel.find_or_create_by(name: r["name"])
      hotel_details = HotelDetail.create()
      hotel_details.address = r["address"]
      hotel_details.hotel = hotel
      hotel_details.url = "#{r["hotel_url"]}?aid=1164511"
      hotel_details.image = r["photo_url"]
      hotel_details.description = r["desc_en"]
      hotel_details.long = r["longitude"]
      hotel_details.lat = r["latitude"]
      hotel_details.currency = r["currencycode"]
      hotel_details.min_rate = r["minrate"]
      hotel_details.service = 2
      hotel.save
      hotel_details.save
    end
  end
end