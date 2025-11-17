class CreateCategoryRelatedLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :category_related_links do |t|
      t.timestamps
      t.references :category, index: true, foreign_key: true
    end
    reversible do |dir|
      dir.up do
        CategoryRelatedLink.create_translation_table! :title => :string,
        :link => :string
      end

      dir.down do
        CategoryRelatedLink.drop_translation_table!
      end
    end
  end
end
