class AddTopConfImageToTranslations < ActiveRecord::Migration[6.0]
  def change
    TopPageSectionsElement.add_translation_fields!({
      :image_file_name => :text,
      :image_file_size => :text,
      :image_content_type => :text,
      :image_updated_at => :text,
    },{
          :migrate_data => true,
          :remove_source_columns => true
        })
  end
end
