class TagGroupToArticle < ActiveRecord::Base
  belongs_to :tag_group
  belongs_to :article
end
