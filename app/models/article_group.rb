class ArticleGroup < ActiveRecord::Base
  has_ancestry
  translates :title
  has_many :article_groupings, dependent: :delete_all
  has_many :articles, through: :article_groupings
  before_save :cache_ancestry

  scope :get_sorted, -> { order(:names_depth_cache).map { |c| ["-" * c.depth + c.title,c.id] } }
  def cache_ancestry
    self.names_depth_cache = path.map(&:id).join('/')
  end

  def title_with_article_count
    "#{self.title} (#{self.articles.count})"
  end
end
