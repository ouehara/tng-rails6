class RelatedArticle < ActiveRecord::Base
  belongs_to :article, :class_name => 'Article'
  belongs_to :related_article, :class_name => 'Article'
end
