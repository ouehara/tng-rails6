class CreateArticleGroups < ActiveRecord::Migration[6.0] 
  def change 
    create_table :article_groups do |t|
      t.string :ancestry,  index: true
      t.timestamps
    end
    reversible do |dir|
      dir.up do
        ArticleGroup.create_translation_table! :title => :string
      end

      dir.down do
        ArticleGroup.drop_translation_table!
      end
    end
  end
end
