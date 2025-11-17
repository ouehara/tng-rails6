class CreateArticleGroupingFavorites < ActiveRecord::Migration[6.0] 
  def change
    create_table :article_grouping_favorites do |t|
      t.integer :group_1
      t.integer :group_2
      t.integer :group_3
      t.integer :group_4
      t.timestamps null: false
    end
  end
end
