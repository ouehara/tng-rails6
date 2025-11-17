class CreatePromoArticle < ActiveRecord::Migration[6.0] 
  def change
    create_table :promo_articles do |t|
      t.belongs_to :articles, index: true
      t.integer  :position, default: 0
      t.string :lang, index: true
    end
  end
end
