# == Schema Information
#
# Table name: hotel_images
#
#  id                   :integer          not null, primary key
#  hotel_landingpage_id :integer
#  image_file_name      :string
#  image_content_type   :string
#  image_file_size      :integer
#  image_updated_at     :datetime
#

class HotelImage  < ActiveRecord::Base
  belongs_to :hotel_landingpage
  has_attached_file :image, styles: { thumb: "220x145>", medium: "800x800>" },url: ':s3_alias_url',processors: [:thumbnail, :paperclip_optimizer],
  :convert_options => {
    :thumb => "-quality 80 -interlace Plane",
    :thumb_2 => "-quality 80 -interlace Plane",
    :square => "-quality 80 -interlace Plane",
    :medium => "-quality 80 -interlace Plane",
    :big => "-quality 80 -interlace Plane",
    }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
