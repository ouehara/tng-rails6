class RssFeed < ActiveRecord::Base
    belongs_to :article
    enum action: {
        blacklist: 1,  # can manage favorites, default value
        promote: 5,
    }
    
end
  