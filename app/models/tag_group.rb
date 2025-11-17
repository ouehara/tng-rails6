class TagGroup < ActiveRecord::Base
    belongs_to :category
    translates :name
    extend FriendlyId
    acts_as_sortable
    friendly_id :name, use: :slugged
    has_many :tag_group_to_articles, dependent: :delete_all
    has_many :articles, through: :tag_group_to_articles
    globalize_accessors :locales => [:en, "zh-hant", "zh-hans", "ja", "th","ko","vi"], :attributes => [:name]
    

    def self.cached_categroy id
        Rails.cache.fetch("tag_group#{I18n.locale.to_s}",expires_in: 0) do
            self.where(category_id: id)
        end
    end

    # tag_groupのslugはメインテーブルにあるため参照しないようにする（xxxテーブル.slug does not existの対応）
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
