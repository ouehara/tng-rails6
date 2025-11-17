class ArticleImageToTranslation < ActiveRecord::Migration[6.0] 
    def self.up
    Article.add_translation_fields!({
      :title_image_file_name => :text,
      :title_image_file_size => :text,
      :title_image_content_type => :text,
      :title_image_updated_at => :text,
    },{
          :migrate_data => true,
          :remove_source_columns => true
        })
    end
end
