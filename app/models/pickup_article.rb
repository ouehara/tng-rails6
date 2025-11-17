# == Schema Information
#
# Table name: pickup_articles
#
#  id         :integer          not null, primary key
#  pickup_id  :integer
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PickupArticle < ActiveRecord::Base
  belongs_to :pickup
  belongs_to :article

  validates :article, presence: true, uniqueness: { scope: [:pickup] }
end
