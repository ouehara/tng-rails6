# == Schema Information
#
# Table name: article_translators
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  article_id :integer
#  lang       :string
#

class ArticleTranslator < ActiveRecord::Base
  belongs_to :user
  belongs_to :article

  validates :user, presence: true
  validates :article, presence: true
  validates :lang, presence: true

  def self.c(uid, aid)
    I18n.available_locales.each do |locale|
      ArticleTranslator.create!(:user_id => uid, :article_id => aid, :lang => locale);
    end
  end
end
