# == Schema Information
#
# Table name: promo_articles
#
#  id          :integer          not null, primary key
#  articles_id :integer
#  position    :integer          default(0)
#  lang        :string
#

class PromoArticle < ActiveRecord::Base
  belongs_to :article
  enum position: { pos_first: 0, pos_second: 1, pos_third: 2, 
  pos_fourth: 3, pos_fifth: 4, pos_sixth:5, 
  pos_six: 6, pos_seven: 7, pos_eight: 8, 
  pos_ten: 9, pos_eleven: 10, pos_twelve:11}

  def self.update_or_create_by(args, attributes)
    obj = self.find_or_create_by(args)
    obj.update(attributes)
    return obj
  end

end
