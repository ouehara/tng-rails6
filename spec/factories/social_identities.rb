# == Schema Information
#
# Table name: social_identities
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  provider    :string
#  uid         :string
#  name        :string
#  nickname    :string
#  email       :string
#  url         :string
#  image_url   :string
#  description :string
#  others      :text
#  credentials :text
#  raw_info    :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :social_identity do
    user nil
    provider {"MyString"}
    uid {"MyString"}
    name {"MyString"}
    nickname {"MyString"}
    email {"MyString"}
    url {"MyString"}
    image_url {"MyString"}
    description {"MyString"}
    others {"MyText"}
    credentials {"MyText"}
    raw_info {"MyText"}
  end
end
