# == Schema Information
#
# Table name: images
#
#  id               :integer          not null, primary key
#  img_file_name    :string
#  img_content_type :string
#  img_file_size    :integer
#  img_updated_at   :datetime
#

class Image < ActiveRecord::Base
  has_attached_file :img, styles: { medium: "600x600>" }, processors: [:thumbnail, :paperclip_optimizer], url: ':s3_alias_url',:s3_protocol => :https,
  :convert_options => {
    :medium => "-quality 75 -interlace Plane",
    }
  validates :img, attachment_presence: true
  validates_attachment :img, 
  content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] },
  size: { in: 0..4.megabytes }

  def medium_url
    self.img.url(:medium)
  end
  def original_url
    self.img.url(:original)
  end
end
