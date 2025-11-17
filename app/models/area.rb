# == Schema Information
#
# Table name: areas
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  ancestry          :string
#  slug              :string
#  in_sidebar        :boolean
#  area_code         :integer
#  prefecture_code   :integer
#  names_depth_cache :string
#  pos               :integer
#  map_position      :integer
#

class Area < ActiveRecord::Base
  has_many :articles
  has_many :hotel_landingpages
  has_ancestry
  translates :name, :description,  :fallbacks_for_empty_translations => true
  globalize_accessors :locales => [:en, "zh-hant", "zh-hans", "ja", "th","ko","vi", "id"], :attributes => [:name, :description]
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :finders]
  validates :name, presence: true
  validates_uniqueness_of :slug
  before_save :cache_ancestry

  def self.by_name_like query
    where("lower(name) LIKE ?", "%#{query.downcase}%").order(:name)
  end
  
  def cache_ancestry
    self.names_depth_cache = path.map(&:slug).join('/')
  end

  def self.sidebar_cache
    Rails.cache.fetch("sidebar_cache",expires_in: 240.hours) do
      self.includes(:translations).where(in_sidebar: true)
    end
  end

  def self.as_csv
    CSV.generate do |csv|
      columns = %w(id slug parent_id) 
      columns += Area.globalize_attribute_names.map do |v| v end
      csv << columns
      all.each do |tag|
        
        
        csv << columns.map{ |attr| tag.send(attr) }
      end
    end
  end

  def self.importCSV(file)
    CSV.foreach(file.path, headers: true) do |row|
      t = Area.find_or_create_by(id: row['id'])
      t.update(row.to_hash)
    end
  end

  # areaのslugはメインテーブルにあるため参照しないようにする（xxxテーブル.slug does not existの対応）
  def self.exists_by_friendly_id?(id)
    return false if id.nil?
    
    where(slug: id).exists? || 
    joins(:friendly_id_slugs).where(
      friendly_id_slugs: { 
        sluggable_type: base_class.to_s, 
        slug: id 
      }
    ).exists?
  end
end
