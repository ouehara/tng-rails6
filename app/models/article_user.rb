# == Schema Information
#
# Table name: article_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  article_id :integer
#  lang       :string
#

class ArticleUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :article

  validates :user, presence: true
  validates :article, presence: true
  validates :lang, presence: true

  def self.c(uid, aid)
    I18n.available_locales.each do |locale|
      ArticleUser.create!(:user_id => uid, :article_id => aid, :lang => locale);
    end
  end
end
