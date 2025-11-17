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

FactoryBot.define do
  factory :hotel do
    name {"Hotel"}
  end
end
