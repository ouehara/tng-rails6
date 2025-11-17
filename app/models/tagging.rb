# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_id     :integer
#  lang       :string
#

class Tagging < ActiveRecord::Base
  belongs_to :tag, :counter_cache => :article_count
  belongs_to :article

  validates :tag, presence: true #, uniqueness: { scope: :article }
  validates :article, presence: true
  before_save :set_lang_true

  def set_lang_true    
    self.lang = I18n.locale
  end
end
