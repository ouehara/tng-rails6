# == Schema Information
#
# Table name: tags
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ancestry      :string
#  slug          :string
#  article_count :integer
#

class Tag < ActiveRecord::Base
  # Class configuration
  MAX_NAME_LENGTH = 100
  translates :name, :description,  :fallbacks_for_empty_translations => false
  globalize_accessors :locales => [:en, "zh-hant", "zh-hans", "ja", "th","ko","vi", "id"], :attributes => [:name, :description]

  # Association
  has_many :taggings, dependent: :delete_all
  has_many :articles, through: :taggings

  # Name is required and must be within 1...MAX_NAME_LENGTH letters.
  validates :name, 
  presence:  { message: "Tag name is required" }, 
  :length => { :minimum => 1, :maximum => MAX_NAME_LENGTH, :message => "Tag should be between 1 and #{MAX_NAME_LENGTH} characters" }, 
  uniqueness: true
  
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :finders]
  # Search tags includes query (case insensitive)
  # @param [String] query search string
  # @return [ActiveRecord::Relation []] Matching tags
  def self.by_name_like query
    where("lower(name) LIKE ?", "#{query.downcase}%").order(:name)
  end

  def self.as_csv
    CSV.generate do |csv|
      columns = %w(id slug published_en) 
      columns += Tag.globalize_attribute_names.map do |v| v end
      csv << columns
      all.each do |tag|
        
        
        csv << columns.map{ |attr| tag.send(attr) }
      end
    end
  end

  def self.importCSV(file)
    CSV.foreach(file.path, headers: true) do |row|
      t = Tag.find_or_create_by(id: row['id'])
      t.update(row.to_hash)
    end
  end

  def published_en
    self.articles.translation_published("en").length
  end

  # tagのslugはメインテーブルにあるため参照しないようにする（xxxテーブル.slug does not existの対応）
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
