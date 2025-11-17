# == Schema Information
#
# Table name: hotel_features
#
#  id                   :integer          not null, primary key
#  hotel_landingpage_id :integer
#  feature              :integer
#



class HotelFeature < ActiveRecord::Base
  belongs_to :hotel_landingpage
  enum feature: {
    bar: 1,  
    parking: 2,
    bus: 3, 
    wifi: 4, 
    onsen: 5,
    smoking: 6,
    nosmoking: 7,
    smokingspace: 8,
    english:9,
    chinese: 10,
    vent: 11,
    tray: 12,
    thermograph: 13,
    temperature: 14,
    spray: 15,
    sheet: 16,
    sanitizer: 17,
    mask: 18,
    hand: 19,
    gargle: 20,
    distance: 21,
    cashless: 22,
  }
end
