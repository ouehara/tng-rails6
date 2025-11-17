class AddDescToTranslation < ActiveRecord::Migration[6.0] 
  def self.up
    Category.add_translation_fields!({
      :description => :text
    },{
          :migrate_data => true,
          :remove_source_columns => true
        })
  end
end
