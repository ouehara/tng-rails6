# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer          default(0)
#  username               :string
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with email and password." do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "is invalid without email." do
    expect(FactoryBot.build(:user, email: "")).not_to be_valid
  end

  it "is invalid without password." do
    expect(FactoryBot.build(:user, password: "")).not_to be_valid
  end

  it "is invalid without username." do
    expect(FactoryBot.build(:user, username: "")).not_to be_valid
  end

  it "is invalid with too short username (minimum #{User::MIN_USERNAME_LENGTH})" do
    expect(FactoryBot.build(:user, username: Faker::Lorem.characters(User::MIN_USERNAME_LENGTH - 1))).not_to be_valid
  end

  it "is invalid with too long username (maximum #{User::MAX_USERNAME_LENGTH})" do
    expect(FactoryBot.build(:user, username: Faker::Lorem.characters(User::MAX_USERNAME_LENGTH + 1))).not_to be_valid
  end

  it "is invalid with incorrect email format." do
    expect(FactoryBot.build(:user, email: "invalid_email_format")).not_to be_valid
  end

  it "is invalid with a duplicate email." do
    created_user = FactoryBot.create(:user)
    expect(FactoryBot.build(:user, email: created_user)).not_to be_valid
  end

  it "is invalid with a duplicate username." do
    created_user = FactoryBot.create(:user, username: "chanshiro")
    expect(FactoryBot.build(:user, username: created_user.username)).not_to be_valid
  end

  it "is invalid with a password less than 5 letters." do
    expect(FactoryBot.build(:user, password: "short")).not_to be_valid
  end

  it "is invalid with a password more than 129 letters." do
    expect(FactoryBot.build(:user, password: Faker::Internet.password(129))).not_to be_valid
  end

  describe "when get articles of user." do
    it "returns articles of the user." do
      user = FactoryBot.create(:user)
      article1 = FactoryBot.create(:article, user: user)
      article2 = FactoryBot.create(:article, user: user)
      article3 = FactoryBot.create(:article, user: user)
      expect(user.articles).to match_array [article1, article2, article3]
    end
  end
end
