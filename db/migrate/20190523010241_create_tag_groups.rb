class CreateTagGroups < ActiveRecord::Migration[6.0] 
  def change
    create_table :tag_groups do |t|
      t.references :category, index: true, foreign_key: true
      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        TagGroup.create_translation_table! :name => :string
      end

      dir.down do
        TagGroup.drop_translation_table!
      end
    end
  end
end
