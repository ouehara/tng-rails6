# == Schema Information
#
# Table name: article_editors
#
#  articles_id :integer
#  users_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  id          :integer          not null, primary key
#  lang        :string
#


class ArticleEditor < ActiveRecord::Base
  belongs_to :article, :foreign_key => "articles_id"
  belongs_to :user, :foreign_key => "users_id"

  def is_locked
    updated_at + 45.seconds > Time.current
  end
  
  def self.is_editing(article_id)
    self.where(:articles_id => article_id).where(:lang => I18n.locale).order("updated_at desc").first
  end

end
