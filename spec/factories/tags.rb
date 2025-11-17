# == Schema Information
#
# Table name: tags
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ancestry      :string
#  slug          :string
#  article_count :integer
#

FactoryBot.define do
  factory :tag do
    name { Faker::Name.name}
  end
end
