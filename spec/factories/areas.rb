# == Schema Information
#
# Table name: areas
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  ancestry          :string
#  slug              :string
#  in_sidebar        :boolean
#  area_code         :integer
#  prefecture_code   :integer
#  names_depth_cache :string
#  pos               :integer
#  map_position      :integer
#

FactoryBot.define do
  factory :area do
    name {"MyString"}
  end
end
