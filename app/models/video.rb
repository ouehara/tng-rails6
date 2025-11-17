class Video < ActiveRecord::Base
    #banner settings
    acts_as_sortable

    #translation fields
    translates :title, :link, :user
end
