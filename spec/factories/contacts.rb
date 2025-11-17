# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string
#  title      :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email      :string
#

FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    title { Faker::Book.title }
    content { Faker::Lorem.sentence }
    email { Faker::Internet.email }
  end
end
