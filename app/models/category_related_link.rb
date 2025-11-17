class CategoryRelatedLink < ActiveRecord::Base
    translates :title, :link
    belongs_to :category
end
