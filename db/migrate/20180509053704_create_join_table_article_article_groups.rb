class CreateJoinTableArticleArticleGroups < ActiveRecord::Migration[6.0] 
  def change
    create_table :article_groupings, id: false do |t|
      t.belongs_to :article
      t.belongs_to :article_group
      t.timestamps null: false 
    end
  end
end