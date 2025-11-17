class AddOptimisticLockToArticle < ActiveRecord::Migration[6.0] 
  def change 
    add_column :articles, :optimistic_lock, :jsonb, :null => false, :default => {"en": 1, "zh-hant": 1,"zh-hans": 1, "ja": 1, "th": 1}
  end
end
