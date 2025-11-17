class CreateTagGroupToArticles < ActiveRecord::Migration[6.0] 
  def change
    create_table :tag_group_to_articles do |t|
      t.belongs_to :tag_group, index: true, foreign_key: true
      t.belongs_to :article, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
