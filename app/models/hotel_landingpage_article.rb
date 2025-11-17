# == Schema Information
#
# Table name: hotel_landingpage_articles
#
#  id                   :integer          not null, primary key
#  hotel_landingpage_id :integer
#  article_id           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#


class HotelLandingpageArticle < ActiveRecord::Base
  belongs_to :hotel_landingpage
  belongs_to :article

  validates :article, presence: true, uniqueness: { scope: [:hotel_landingpage] }
end
