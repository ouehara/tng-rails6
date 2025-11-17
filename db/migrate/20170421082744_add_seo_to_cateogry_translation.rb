class AddSeoToCateogryTranslation < ActiveRecord::Migration[6.0] 
  def self.up
    Category.add_translation_fields! seo_title: :text
  end

  def self.down
    remove_column :category_translations, :seo
  end
end
