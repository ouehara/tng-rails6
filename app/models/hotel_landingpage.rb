# == Schema Information
#
# Table name: hotel_landingpages
#
#  id       :integer          not null, primary key
#  area_id  :integer
#  position :integer          default(1), not null
#
#for covid page:
#description = information
#Summary = safety information
#Price = benefit
class HotelLandingpage  < ActiveRecord::Base
  translates :name, :description, :price, :summary, :url, :address, :official_text, :recommend_text, :published, :img_src, :maps, :fallbacks => false
  acts_as_sortable
  globalize_accessors :locales => ["en", "zh-hant", "zh-hans", "ja", "th","ko","vi","id"], :attributes => [ :name, :description, :price, :summary, :url, :address, :official_text, :recommend_text, :published,:maps]
  default_scope { order(name: :asc) }
  has_many :pickup_hotel_lp, :foreign_key => "hotel_landingpages_id"
  has_many :hotel_images, dependent: :destroy
  has_many :hotel_landingpage_articles, dependent: :delete_all
  has_many :hotel_features, dependent: :delete_all
  has_many :articles, through: :hotel_landingpage_articles
  belongs_to :area
  scope :area_filter, -> (area) { where area: area }
  enum category: {
    hotel: 1,
    c_hotel: 2,
    c_transport: 3,
    c_restaurant: 4,
    c_shops: 5,
    c_sightseeing: 6,
    c_other: 7,
  }
  accepts_nested_attributes_for :hotel_landingpage_articles, allow_destroy: true
  def fallbacks(locale)
    [I18n.locale]
  end


  def self.as_csv
    CSV.generate do |csv|
      columns = %w(id position category) 
      columns += HotelLandingpage.globalize_attribute_names.map do |v| v end
      csv << columns
      all.each do |tag|
        
        
        csv << columns.map{ |attr| tag.send(attr) }
      end
    end
  end

  def self.importCSV(file)
    CSV.foreach(file.path, headers: true) do |row|
      t = HotelLandingpage.find_or_create_by(id: row['id'])
      t.update(row.to_hash)
    end
  end
end
