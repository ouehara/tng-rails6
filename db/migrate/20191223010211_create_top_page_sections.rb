class CreateTopPageSections < ActiveRecord::Migration[6.0]
  def change
    create_table :top_page_sections do |t|
      t.integer :display
      t.timestamps
    end
    reversible do |dir|
      dir.up do
        TopPageSection.create_translation_table! :title => :string, 
        :more_btn_link => :string,
        :more_btn_text => :string,
        :active => :bool
      end

      dir.down do
        TopPageSection.drop_translation_table!
      end
    end
  end
end
