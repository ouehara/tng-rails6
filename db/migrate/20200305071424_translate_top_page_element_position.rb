class TranslateTopPageElementPosition < ActiveRecord::Migration[6.0]
  def change
        TopPageSectionsElement.add_translation_fields!({
          :position => :integer,
        },{
              :migrate_data => true,
              :remove_source_columns => true
            })
  end
end
