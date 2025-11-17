# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string
#  slug       :string
#  position   :integer
#  css_class  :string
#

class Category < ActiveRecord::Base
  validates :name, presence: true
  validates :slug, uniqueness: true, allow_nil: true
  
  translates :name, :seo_title, :description,  :fallbacks_for_empty_translations => true
  globalize_accessors :locales => [:en, "zh-hant", "zh-hans", "ja", "th","ko","vi", "id"], :attributes => [:name, :seo_title, :description]
  
  # FriendlyIdの前に、独自の exists_by_friendly_id? を定義
  class << self
    def exists_by_friendly_id?(id)
      return false if id.nil?
      where(slug: id).exists?
    end
  end
  
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  has_many :articles, dependent: :nullify
  has_many :category_related_links
  accepts_nested_attributes_for :category_related_links
  acts_as_sortable
  has_ancestry
  before_save :cache_ancestry
  after_save :flush_cache
  # Search categories includes query (case insensitive)
  # @param [String] query search string
  # @return [ActiveRecord::Relation []] Matching categories
  def cache_ancestry
    self.names_depth_cache = path.map(&:name).join('/')
  end
  def self.by_name_like query
    where("lower(name) LIKE ?", "%#{query.downcase}%").order(:name)
  end

  def self.cached_menu
     Rails.cache.fetch("menu_l#{I18n.locale.to_s}",expires_in: 0) do
      self.roots.where(active: true).order(position: :asc).to_a
    end
  end

  def self.importCSV(file)
    CSV.foreach(file.path, headers: true) do |row|
      t = Category.find_or_create_by(id: row['id'])
      t.update(row.to_hash)
    end
  end

  def flush_cache
      Rails.cache.delete("menu_l#{I18n.locale.to_s}")
  end

  def self.as_csv
    CSV.generate do |csv|
      columns = %w(id slug position parent_id) 
      columns += Category.globalize_attribute_names.map do |v| v end
      csv << columns
      all.each do |tag|
        csv << columns.map{ |attr| tag.send(attr) }
      end
    end
  end

  def as_json options={}
  {
    id: id,
    page_code: slug,
    page_name: name,
    index: {
      url: Rails.application.routes.url_helpers.category_path(I18n.locale, self.slug),
      id: 'dunno'
    },
    items: children,
    ancestry: ancestry,
  }
  end

  # FriendlyIdのバリデーションをスキップ
  def run_friendly_id_validations
    # 何もしない
  end
end
