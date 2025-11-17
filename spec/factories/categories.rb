# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string
#  slug       :string
#  position   :integer
#  css_class  :string
#

FactoryBot.define do
  factory :category do
    name { Faker::Book.genre }
  end
end
