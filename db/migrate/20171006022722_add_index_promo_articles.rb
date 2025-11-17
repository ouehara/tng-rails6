class AddIndexPromoArticles < ActiveRecord::Migration[6.0] 
  def change
    add_index(:promo_articles, [:position,:lang])
  end
end
