class AddDescriptionToTags < ActiveRecord::Migration[6.0] 
    def change
      reversible do |dir|
        dir.up do
          Tag.add_translation_fields! description: :text
        end
  
        dir.down do
          remove_column :tag_translations, :description
        end
      end
    end
end
