class CreateTopPageSectionsElements < ActiveRecord::Migration[6.0]
  def change
    create_table :top_page_sections_elements do |t|
      t.timestamps
    end
    reversible do |dir|
      dir.up do
        TopPageSectionsElement.create_translation_table! :title => :string, 
        :title => :string,
        :link => :string
      end

      dir.down do
        TopPageSectionsElement.drop_translation_table!
      end
    end
  end
end
