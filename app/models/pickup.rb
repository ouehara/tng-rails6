# == Schema Information
#
# Table name: pickups
#
#  id                 :integer          not null, primary key
#  title              :string
#  content            :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  published_at       :datetime
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Pickup < ActiveRecord::Base
  has_many :pickup_articles, dependent: :delete_all
  has_many :articles, through: :pickup_articles

  has_attached_file :image, styles: { large: "1280x1024>", medium: "640x512>", thumb: "320x256>", square: "512x512#" }
  validates_attachment :image, content_type: { content_type: ["image/jpeg", "image/png"] }, size: { in: 0..1.megabytes }

  validates :title, presence: true
  scope :published, -> {where.not(published_at: nil)}
  # Nested attributes
  accepts_nested_attributes_for :pickup_articles, allow_destroy: true

  # make pickup publish
  def publish
    update(published_at: Time.now)
  end

  def medium_url
    self.image.url(:medium)
  end
  # make pickup unpublish
  def unpublish
    update(published_at: nil)
  end

  def self.by_name_like query
    where("lower(title) LIKE ?", "%#{query.downcase}%").order(:title)
  end
  # check if published
  def published?
    published_at.present?
  end
end
