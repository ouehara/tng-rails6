# == Schema Information
#
# Table name: hotels
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string
#

class Hotel < ActiveRecord::Base
  validates :name, presence: true
  has_many :hotel_details
  enum service: {
    undefined: 0,
    agoda: 1,
    booking: 2,
  } 

  def self.by_name_like query
    q = query.downcase
    where("LOWER(name) LIKE  '%#{q}%'").order(:name)
  end
  
end
