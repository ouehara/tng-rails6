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

class User < ActiveRecord::Base

  # Validation Configuration
  MIN_USERNAME_LENGTH = 5
  MAX_USERNAME_LENGTH = 20

  # For OAuth temp_email
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  # Remove user_id from articles when the user is deleted
  has_many :article_users
  has_many :articles, dependent: :nullify, through: :article_users
  has_many :social_identities, dependent: :destroy

  has_many :curator_requests, dependent: :destroy
  has_many :article_editor, :foreign_key => "users_id"

  # after_save :flush_user_articles_cache
  # User role
  # as our user roles are exclusive and user can have only ONE role
  #
  enum role: {
    registered: 0,  # can manage favorites, default value
    tester: 5,
    curator: 10, # can post articles
    editor: 20, # can manage articles
    administrator: 30 # can manage all
  }

  translates :facebook,
      :instagram,
      :twitter,
      :google,
      :pintrest,
      :description
  globalize_accessors :locales => ["en", "zh-hant", "zh-hans", "ja","th", "vi", "ko", "id"], :attributes => [:facebook,
      :instagram,
      :twitter,
      :google,
      :pintrest,
      :description]
  # Validations
  validates :username, presence: true, uniqueness: true, length: { in: MIN_USERNAME_LENGTH...MAX_USERNAME_LENGTH }

  # Attachment
  has_attached_file :avatar,
    styles: { large: "1024x1024#", medium: "512x512#", thumb: "100x100#" }, :default_url => "/assets/articles/default_avatar.png"

  validates_attachment :avatar, content_type: { content_type: ["image/jpeg", "image/png"] }, size: { in: 0..1.megabytes }

  def email_verified?
    email && email !~ TEMP_EMAIL_REGEX
  end

  def reset_confirmation!
    update(confirmed_at: nil)
  end
  def is_able_to_post
    user.role == role
  end

  def can_admin_translations?
    self.administrator?
  end

  def self.search(user_name)
    if user_name
        user_name.downcase!
        where('LOWER(username) LIKE ?', "%#{user_name}%")
    else
        all
    end
  end

  def flush_user_articles_cache
    self.articles.each do |a|
      a.flush_cached_users
    end
  end

end
