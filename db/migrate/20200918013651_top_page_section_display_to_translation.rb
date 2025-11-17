class TopPageSectionDisplayToTranslation < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        TopPageSection.add_translation_fields!({
          :display => :integer,
        }, {
          :migrate_data => true,
          :remove_source_columns => true
        })
      end

      dir.down do
        TopPageSection.drop_translation_table! :migrate_data => true
      end
    end
  end
end
