# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_id     :integer
#  lang       :string
#

FactoryBot.define do
  factory :tagging do
    tag nil
    article nil
  end
end
