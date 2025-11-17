# == Schema Information
#
# Table name: articles
#
#  id                :integer          not null, primary key
#  excerpt           :jsonb
#  contents          :jsonb            not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  category_id       :integer
#  published_at      :datetime
#  impressions_count :integer          default(0)
#  is_translated     :jsonb
#  disp_title        :jsonb
#  area_id           :integer
#  sponsored_content :boolean
#  schedule          :jsonb
#  slug              :string
#  lang_updated_at   :jsonb
#  optimistic_lock   :jsonb            not null
#

FactoryBot.define do
  factory :article do
    user nil
    title { Faker::Lorem.sentence(3) }
    excerpt { Faker::Lorem.sentence(12) }
    published_at nil
    slug nil
    contents {'[]'}
  end
end
