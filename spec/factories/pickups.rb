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

FactoryBot.define do
  factory :pickup do
    title { Faker::Name.name }
    content { Faker::Lorem.sentence }
  end
end
