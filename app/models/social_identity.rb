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

class SocialIdentity < ActiveRecord::Base
  belongs_to :user
  store :others

  validates :uid, presence: true, uniqueness: { scope: [:provider] }

  def self.find_for_oauth(auth)
    identity = find_or_create_by(uid: auth.uid, provider: auth.provider)
    identity.save_oauth_data!(auth)
    identity
  end

  def save_oauth_data!(auth)
    return unless valid_oauth?(auth)

    provider = auth["provider"]
    adapter = adapter(provider, auth)

    update(
      uid: adapter.uid,
      name: adapter.name,
      nickname: adapter.nickname,
      email: adapter.email,
      url: adapter.url,
      image_url: adapter.image_url,
      description: adapter.description,
      credentials: adapter.credentials,
      raw_info: adapter.raw_info
    )

  end

  private

  def adapter(provider, auth)
    class_name = "#{provider}".classify
    "OAuth::OAuthAdapter::#{class_name}".constantize.new(auth)
  end

  def valid_oauth?(auth)
    (provider.to_s == auth["provider"].to_s) && (uid == auth["uid"])
  end
end
