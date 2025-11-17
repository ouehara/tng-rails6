# == Schema Information
#
# Table name: articles
#
#  id                :integer          not null, primary key
#  excerpt           :jsonb
#  contents          :jsonb            not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  category_id       :integer
#  published_at      :datetime
#  impressions_count :integer          default(0)
#  is_translated     :jsonb
#  disp_title        :jsonb
#  area_id           :integer
#  sponsored_content :boolean
#  schedule          :jsonb
#  slug              :string
#  lang_updated_at   :jsonb
#  optimistic_lock   :jsonb            not null
#

class Article < ActiveRecord::Base
  # include PgSearch

  # Association
  has_many :promo_article,  :foreign_key => "articles_id"
  has_many :article_users, dependent: :delete_all
  has_many :users, through: :article_users
  has_many :article_translators, dependent: :delete_all
  belongs_to :category
  belongs_to :area
  
  has_many :related_articles, :class_name => 'RelatedArticle', :foreign_key => 'article_id'
  has_many :taggings, dependent: :delete_all
  has_many :tags, through: :taggings
  has_many :tag_group_to_articles, dependent: :delete_all
  has_many :tag_groups, through: :tag_group_to_articles
  has_many :article_groupings, dependent: :delete_all
  has_many :article_groups, through: :article_groupings
  has_many :article_editor, :foreign_key => "articles_id"
  has_many :impressions, :as=>:impressionable
  has_attached_file :title_image, styles: {
    thumb: '410x261#',
    thumb_2: '170x110>',
    square: '400x400#',
    topThumb: '301x160#',
    artTop: '720x240#',
    medium: '750x750>',
    sp: '750x680#',
    big: '1035x460#',
  },:s3_protocol => :https,  :default_url => "/assets/articles/default.jpg", url: ':s3_alias_url', :path => ':locale/:class/:attachment/:id_partition/:style/:filename',
  processors: [:thumbnail, :paperclip_optimizer],
  :convert_options => {
    :thumb => "-quality 100 -interlace Plane",
    :thumb_2 => "-quality 100 -interlace Plane",
    :square => "-quality 100 -interlace Plane",
    :medium => "-quality 75 -interlace Plane",
    :big => "-quality 75 -interlace Plane",
    :sp => "-quality 75 -interlace Plane",
    }
    amoeba do
      exclude_association :translations
    end
  # Impressionable
  is_impressionable
  before_create :init_article
  accepts_nested_attributes_for :taggings
  # pg_search_scope :search_for, against: %i(disp_title excerpt), :using => {
  #                   :tsearch => {:prefix => true}
  #                 }
  # get published articles
  attr_accessor :locale
  scope :published, -> { where.not(published_at: nil) }
  scope :translation_published, -> (local = "en") {select("articles.*, contents->'#{local}' as contents, excerpt->'#{local}' as excerpt, disp_title->'#{local}' as disp_title").where("(is_translated->>'#{local}' = 'publish' OR is_translated->>'#{local}' = 'future') AND (schedule->>'#{local}')::timestamp  <= ('#{ Time.now}')::timestamp AND unlist=false").article}
  scope :published_coupon,  -> (local = "en") {select("articles.*, contents->'#{local}' as contents, excerpt->'#{local}' as excerpt, disp_title->'#{local}' as disp_title").where("(is_translated->>'#{local}' = 'publish' OR is_translated->>'#{local}' = 'future') AND (schedule->>'#{local}')::timestamp  <= ('#{ Time.now}')::timestamp").coupon}
  scope :translation_published_timed, -> (local = "en", date = Time.now) {select("articles.*, contents->'#{local}' as contents, excerpt->'#{local}' as excerpt, disp_title->'#{local}' as disp_title").where("(is_translated->>'#{local}' = 'publish' OR is_translated->>'#{local}' = 'future') AND (schedule->>'#{local}')::timestamp  >= ('#{date}')::timestamp AND unlist=false").article}
  scope :translation_published_simple, -> (local = "en") {select("articles.id, articles.slug, articles.excerpt->'#{local}' as excerpt, articles.disp_title->'#{local}' as disp_title, articles.published_at, articles.schedule, articles.is_translated, articles.category_id, articles.area_id").where("(articles.is_translated->>'#{local}' = 'publish' OR articles.is_translated->>'#{local}' = 'future') AND (articles.schedule->>'#{local}')::timestamp  <= ('#{Time.now}')::timestamp AND unlist=false").article}
  scope :where_translation_published, -> (local = "en") {where("(articles.is_translated->>'#{local}' = 'publish' OR articles.is_translated->>'#{local}' = 'future') AND (articles.schedule->>'#{local}')::timestamp  <= ('#{Time.now}')::timestamp")}
  scope :select_translated, -> (local = "en") {where.not("is_translated->>'#{local}' = 'null'")}
  
  # PGroonga
  # scope :full_tetagged_withxt_title, -> query { where("title @@ ?", query) }
  # scope :full_text_excerpt, -> query { where("excerpt @@ ?", query) }
  # scope :full_text_search, -> query { where("(title @@ 'string @ \"#{query}\"' OR excerpt @@ 'string @ \"#{query}\"')", query, query) }

  # Validations
  validates_attachment_content_type :title_image, :content_type => /\Aimage\/.*\Z/

  # Cloudsearch sync
  after_save :update_index, :flush_cache
  after_commit :update_index
  before_destroy :delete_index
  before_update :update_date, :check_optimistic_lock

  translates :title, :slug, :title_image_file_name, :title_image_file_size, :title_image_content_type, :title_image_updated_at, :canonical
  # Friendly ID
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history, :finders, :globalize]
  globalize_accessors :locales => ["en", "zh-hant", "zh-hans", "ja", "th","ko","vi", "id"], :attributes => [:slug, :title_image_file_name]
  has_paper_trail
  # Cloud Search
  INDEXED_KEYS = ["text", "desc"]

  enum template: {
    article: 1,  # can manage favorites, default value
    landingpage: 2,
    coupon: 3,
    otomo_tour: 4

  }

  class Translation
    validates :slug, presence: true
    validates :slug, uniqueness: { scope: :locale, case_sensitive: false }
  end
  
  def self.in_groupings(groups)
    ids = groups.
      map { |name| Article.joins(:article_groups).where(:article_groups=> {"id": name}) }.
      map { |relation| relation.pluck(:id).to_set }.
      inject(:intersection).to_a
  
    where(id: ids)
  end

  def get_i18n(local)
    if self.is_translated["#{local}"]
      self.contents = self.contents["#{local}"]
      self.excerpt = [self.excerpt["#{local}"]]
      self.disp_title = [self.disp_title["#{local}"]]
    else
      self.contents = self.contents["#{I18n.default_locale}"]
      self.excerpt = [self.excerpt["#{I18n.default_locale}"]]
      self.disp_title = [self.disp_title["#{I18n.default_locale}"]]
    end
  end

  def should_generate_new_friendly_id?
   true
  end

  def translators
    self.article_translators.where(:article_translators => {:lang => I18n.locale}).limit(1).first
  end


  def userTranslator
    Rails.cache.fetch([self.class.name,translators.user_id ,I18n.locale, :article_translators], expires_in: 0) do
      User.find(translators.user_id)
    end
  end

  def remake_slug
    self.update_attribute(:slug, nil)
    self.save!
  end

  # if the article is published
  def published?
    published_at.present?
  end

  def cached_users
    Rails.cache.fetch(["mail_removed",self.id,self.class.name, user_ids, :users,I18n.locale], expires_in: 0) do
      self.user
    end
  end
  
  def flush_cached_users
    I18n.available_locales.each do |lang|
      Rails.cache.delete(["mail_removed",self.id,self.class.name, user_ids, :users,lang])
    end
  end

  def cached_category
    Rails.cache.fetch([self.class.name, category_id, :categories], expires_in: 0) do
      self.category
    end
  end

  def get_path
    if I18n.locale == :en
      return '/'+self.slug
    end
    Rails.application.routes.url_helpers.article_path(I18n.locale,self)
  end

  
  def get_url
    Rails.application.routes.url_helpers.article_url(I18n.locale,self.slug)
  end

  def cached_area
    Rails.cache.fetch([self.class.name, area_id, :areas], expires_in: 0) do
      self.area
    end
  end

  def cached_tags
    Rails.cache.fetch([self.class.name, tag_ids, :tags, I18n.locale], expires_in: 0) do
      self.lang_tags.to_a
    end
  end

  def self.cached_top_articles
    Rails.cache.fetch("top-articles-#{I18n.locale}",expires_in: 0) do
      self.translation_published_simple(I18n.locale).includes(:translations).joins(:impressions).group("impressions.impressionable_id, articles.id").order("count(impressions.id) DESC").where('impressions.created_at >= ?', Time.now-7.days).limit(5).to_a
    end
  end

  

  def self.spotlight_cached
    Rails.cache.fetch("spotlight-37678-#{I18n.locale}",expires_in: 0) do
      self.where("id=37678").translation_published(I18n.locale).to_a
    end
  end

  def self.to_csv
    attributes = %w{id disp_title lang excerpt get_url category_name area_name area_small all_tags medium_url pub}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |a|
        csv << attributes.map{ |attr| a.send(attr) }
      end
    end
  end

  def lang
    I18n.locale
  end

  def category_name
    cached_category.name unless cached_category.nil?
  end

  def prefecture
    if !cached_area.nil? && cached_area.depth > 1
      cached_area.parent.name unless cached_area.parent.nil?
    else
      cached_area.name unless cached_area.nil?
    end
  end

  def area_name
    if !cached_area.nil? && cached_area.ancestors
      cached_area.parent.name unless cached_area.parent.nil?
    else
      cached_area.name unless cached_area.nil?
    end
  end
  def area_small
    if !cached_area.nil? && cached_area.ancestors
      cached_area.name unless cached_area.nil?
    else
      return ""
    end
  end
  def pub
    1
  end
  def self.find_cached id
    Rails.cache.fetch("article-"+id,expires_in: 0) do
      self.friendly.find(id)
    end
  end
  def self.get_cached_articles_for_cat id
    Rails.cache.fetch([self.class.name, id,'new_cached','article',I18n.locale ], expires_in: 1.days) do
      self.where(category_id: id)
      .translation_published_simple(I18n.locale)
      .limit(3).order("(schedule->>'#{I18n.locale}')::timestamp desc")
    end
  end
  def get_related_articles
    Rails.cache.fetch("related-articles-#{self.id}-#{I18n.locale}",expires_in: 0) do
      Article.joins(:taggings)
      .where('articles.id != ?', self.id)
      .where(taggings: { tag_id: self.tag_ids })
      .where(area_id: self.area_id)
      .group("articles.id")
      .limit(6)
    end
  end

  def flush_cache
    Rails.cache.delete("article-#{self.id}")
    Rails.cache.delete("article-#{self.slug_was}")
  end

  def flush_cached_top_articles(local)
    Rails.cache.delete("top-articles-#{locale}")
  end

  # publish article
  def publish
    self.published_at = Time.now
  end

  def self.importCSV(file)
    CSV.foreach(file.path, headers: true) do |row|
      t = Article.where(id: row['id'])
      t.update(row.to_hash)
    end
  end

  # unpublish the article
  def unpublish
    self.update(published_at: nil)
  end
  def all_related=(ids)
    RelatedArticle.where(article_id: self.id).delete_all
    rl = ids.split(",").map do |id|
      r = RelatedArticle.new
      r.article_id = self.id
      r.related_article_id = id
      r.save
    end
  end
  
  def all_tags=(names)
    Tagging.where(article_id: self.id).where(lang: I18n.locale).delete_all
    tags = names.split(",").map do |name|
      a = Tag.where(name: name.strip).first
      unless !a
        t = Tagging.new
        t.article_id = self.id
        t.tag_id = a.id
        t.save
      end
    end
  end

  def all_tags
    self.tags.where("lang='#{I18n.locale}'").map(&:name).join(", ")
  end

  def all_tag_groups
    self.tag_groups.map(&:name).join(", ")
  end

  def all_tag_groups=(ids)
    TagGroupToArticle.where(article_id: self.id).delete_all
    tags = ids.split(",").map do |id|
      t = TagGroupToArticle.new
      t.article_id = self.id
      t.tag_group_id = id
      t.save
    end
  end
  
  def lang_tags
    self.tags.where("lang='#{I18n.locale}'")
  end

  def get_areas
    self.tags.map(&:name).join(", ")
  end

  def user
    exclude_columns = ['password', 'email','role']
    columns = User.column_names - exclude_columns
    test = self.users.select(columns).where(:article_users => {:lang => I18n.locale.to_s}).limit(1).first
    puts test.inspect
    test
  end

  def setAuthor(id)
    a = self.article_users.where(:lang => I18n.locale).first
    if a.nil?
      a = ArticleUser.create!(:user_id => id, :article_id => self.id, :lang => I18n.locale.to_s);
      a.save
      return
    end
    a.user_id = id ;
    a.save
  end

  def setContent(content)
    self.contents[I18n.locale.to_s] = content
  end

  def setSchedule(content)
    if self.schedule.nil?
      self.schedule = {}
      self.schedule[I18n.locale.to_s] = content
    else
      self.schedule[I18n.locale.to_s] = content
    end
  end

  def setExcerpt(content)
    self.excerpt[I18n.locale.to_s] = content
  end

  def setDispTitle(content)
    self.disp_title[I18n.locale.to_s] = content
  end

  def setTranslator(id)
    a = self.article_translators.where(:lang => I18n.locale).first
    if a.nil?
      a = ArticleTranslator.create!(:user_id => id, :article_id => self.id, :lang => I18n.locale);
    end
    a.user_id = id ;
    a.save
  end

  def title_image_en
    orig = I18n.locale
    I18n.locale = "en"
    img = self.title_image.url(:medium)
    I18n.locale = orig
    img
  end

  def title_image_zh_hant
    orig = I18n.locale
    I18n.locale = "zh-hant"
    img = self.title_image.url(:medium)
    I18n.locale = orig
    img
  end
  def title_image_zh_hans
    orig = I18n.locale
    I18n.locale = "zh-hans"
    img = self.title_image.url(:medium)
    I18n.locale = orig
    img
  end
  def title_image_ja
    orig = I18n.locale
    I18n.locale = "ja"
    img = self.title_image.url(:medium)
    I18n.locale = orig
    img
  end
  def title_image_th
    orig = I18n.locale
    I18n.locale = "th"
    img = self.title_image.url(:medium)
    I18n.locale = orig
    img
  end
  def medium_url
    self.title_image.url(:medium)
  end
  def original_url
    self.title_image.url(:original, timestamp: false)
  end
  def top_thumb_url
    self.title_image.url(:topThumb)
  end
  def thumb_url
    self.title_image.url(:thumb)
  end
  def big_url
    self.title_image.url(:big)
  end
  def sp_url
    self.title_image.url(:sp)
  end
  def square_url
    self.title_image.url(:square)
  end
  #find articles by tagname
  def self.tagged_with(name)
    Tag.friendly.find(name).articles.group(:article_id, "articles.id")
  end

  def self.find_by_area(name)
    Area.friendly.find(name).articles
  end

  def self.find_by_author(name)
    User.find_by_username(name).articles
  end

  def self.find_by_pickup(name)
    Pickup.find_by_title!(name).articles
  end

  def update_date
    if self.lang_updated_at.nil?
      self.lang_updated_at = {}
    end

    self.lang_updated_at[I18n.locale] = DateTime.now
  end

  def check_optimistic_lock
    if self.optimistic_lock_was[I18n.locale.to_s].to_s  == "" || self.optimistic_lock_was[I18n.locale.to_s].to_s == self.optimistic_lock[I18n.locale.to_s].to_s
      self.optimistic_lock[I18n.locale.to_s] = self.optimistic_lock[I18n.locale.to_s].to_i + 1    
      true
    else
      self.errors[:base] << "Error on save: Article version out of date please reload the article"
      false
    end
  end
  
  def lock_version=(numb)
    self.optimistic_lock[I18n.locale.to_s] = numb
  end

  def lock_version
    self.optimistic_lock[I18n.locale.to_s]
  end

  def init_article
    translated = {}
    translated[I18n.locale] = "draft"
    self.excerpt = self.excerpt != nil ? self.excerpt : Hash[I18n.locale, '']
    self.contents = !self.contents.empty? ? self.contents :  Hash[I18n.locale, []]
    self.disp_title = self.disp_title != nil ? self.disp_title : Hash[I18n.locale, self.title]
    self.is_translated =  translated
  end

  def self.as_csv(id)
    CSV.generate do |csv|
      columns = ['id','title','slug','area', 'category']
      
      csv << columns
      translation_published(I18n.locale).where(area_id: id).each do |el|
        val = [el.id, el.disp_title, el.slug,el.area.name, el.category.name]
        
        csv << val
      end
    end
  end

  # =================================================================
  # Cloud Search helper methods
  # =================================================================

  # Create title and excerpt hash for cloud search upload
  # @return [Hash]
  # # {"en" => ["english title", "english excerpt"], "ja" => ["english title", "english excerpt"] }
  def as_field_data
    json_hash = {}
    is_translated.each do |lang, status|
      # if status == "publish"
      lng = lang.sub("-", "_")
      json_hash["title_"+lng] = disp_title[lang].nil? ? '' :  disp_title[lang]
      json_hash["desc_"+lng] = excerpt[lang].nil? ? '' : excerpt[lang]
      # json_hash["full_"+lng] = contents[lang]
      if !contents[lang].nil? && contents[lang].count > 0
        cont_lang = contents[lang]
        only_cont = cont_lang.map { |value| value["content"] }
        only_cont.compact!
        only_text = only_cont.map { |value| value["text"] }
        only_text.compact!
        json_hash["full_"+lng] = only_text
      end
      # end
    end
    # json_hash["published"] = (published_at.nil? ? 0 : 1)
    json_hash
  end

  def sanitize_value(value)
    if value.is_a?(String)
      # doc.aws.amazon.com
      # 無効な文字に一致する次の正規表現を使用して、無効な文字を削除することができます/[^\u0009\u000a\u000d\u0020-\uD7FF\uE000-\uFFFD]/
      # regex = /[^\u0009\u000a\u000d\u0020-\uD7FF\uE000-\uFFFD]/
      regex = /[\u0008]/

      value.gsub(regex, '')
    elsif value.is_a?(Array)
      value.map { |item| sanitize_value(item) }
    else
      value
    end
  end

  # Add Article content to Cloud Search Index
  def add_to_index
    field_data = as_field_data

    if field_data.count < 1
      Rails.logger.info "This article has no data Article[#{id}]"
      return
    end

    begin
      Aws::CloudSearchDomain::Client.new({
        endpoint: ENV['TNG_CLOUD_SEARCH_ENDPOINT_DOCUMENT']
      }).upload_documents({
        documents: [
          {
            type: 'add',
            id: id,
            fields: field_data
          }
       ].to_json,
       content_type: 'application/json'
       })
     rescue => e
       Rails.logger.error e.message
     end
  end

  def add_to_index_sanitized
    field_data = as_field_data
    sanitized_field_data = field_data.transform_values { |value| sanitize_value(value) }

    if field_data.count < 1
      Rails.logger.info "This article has no data Article[#{id}]"
      return
    end

    begin
      Aws::CloudSearchDomain::Client.new({
        endpoint: ENV['TNG_CLOUD_SEARCH_ENDPOINT_DOCUMENT']
      }).upload_documents({
        documents: [
          {
            type: 'add',
            id: id,
            fields: sanitized_field_data
          }
        ].to_json,
        content_type: 'application/json'
      })
    rescue => e
      Rails.logger.error e.message
    end
  end

  # Update Index
  def update_index
    add_to_index
  end

  # Delete Index
  def delete_index
    begin
      Aws::CloudSearchDomain::Client.new({
        endpoint: ENV['TNG_CLOUD_SEARCH_ENDPOINT_DOCUMENT']
      }).upload_documents({
        documents: [
          {
            type: 'delete',
            id: id
          }
       ].to_json,
       content_type: 'application/json'
       })
    rescue => e
      Rails.logger.error e.message
    end
   end

   def self.update_all_index
     find_each do |article|
       field_data = article.as_field_data
       unless field_data.empty?
         article.add_to_index
       end
     end
   end

   def get_versions
    v = []
    versions.sort_by{|ver| -ver[:id]}.each do |version|    
      unless version.nil? 
        v << {date: version.created_at,id:  version.id}
      end
    end
    v
   end
   # Search Cloud Search Index
   # @return [Seahorse::Client::Response] AWS Cloud Search Response
   # @example search "ramen" with page 2 and size 3
   # Article.search(query: "ramen", page: 2, size: 3)
   def self.search (opts={})
     default_options = {
       size: 30,
       query: "*:*",
       page: 1
     }
     opts = opts.reverse_merge(default_options)

     #  Set Page
     page = opts[:page]
     opts.delete :page

     opts[:start] =  (page-1) * opts[:size]

     Aws::CloudSearchDomain::Client.new({
       endpoint: ENV['TNG_CLOUD_SEARCH_ENDPOINT_SEARCH']
     }).search(opts)
   end

   # Search articles
   def self.full_text_search(opts = {})
     default_options = {
       size: 70,
       query: "*:*",
       page: 1,
       query_parser: "simple",
       query_options: '{"defaultOperator": "and"}'
     }

     opts = opts.reverse_merge(default_options)
     article_ids = self.search(opts).data.hits.hit.map { |e| e.id.to_i }
     Article.where(id: article_ids)
   end
end
