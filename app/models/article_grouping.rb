class ArticleGrouping < ActiveRecord::Base
  belongs_to :article_group
  belongs_to :article
  validates :article, uniqueness: { scope: [:article_group] }
end
