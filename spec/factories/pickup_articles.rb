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

FactoryBot.define do
  factory :pickup_article do
    pickup nil
    article nil
  end
end
