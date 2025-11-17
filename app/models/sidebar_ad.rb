class SidebarAd < ActiveRecord::Base
  after_initialize :init_sidebar_ad
  acts_as_sortable

  has_attached_file :banner,
  styles: {
    regular: '500x500>',
  },
  :s3_protocol => :https,  :default_url => "/assets/articles/default.jpg",
  :path => ':locale/:class/:attachment/:id_partition/:style/:filename',
  processors: [:thumbnail, :paperclip_optimizer],
  :convert_options => {:regular => "-quality 75 -interlace Plane"}

  translates :banner_file_name, :banner_file_size,
  :banner_content_type, :banner_updated_at, :publish_start,
  :publish_end, :url
  #validation
  validates_attachment_content_type :banner, :content_type => /\Aimage\/.*\Z/
  validates :analytics_category, presence: true
  validates :analytics_label, presence: true
  validates :publish_start, presence: true
  validates :url, format: { with: URI.regexp }, allow_blank: true
  #translation validation
  after_save :flush_cache
  scope :published, -> {
    joins(:translations).where("sidebar_ad_translations.publish_start <= '#{Time.now()}' AND
    (sidebar_ad_translations.publish_end IS NULL OR
      sidebar_ad_translations.publish_end > '#{Time.now}'
    )") }

  def init_sidebar_ad
    self.publish_start = self.publish_start.present?  ? self.publish_start : Time.now()
  end

  def banner_url
    self.banner.url(:original)
  end

  def self.get_cached
    Rails.cache.fetch("sidebar-ads-#{I18n.locale}",expires_in: 0) do
      self.with_translations(I18n.locale).published.order(:position)
    end
  end
  def flush_cache
    Rails.cache.delete("sidebar-ads-#{I18n.locale}")
  end
end
