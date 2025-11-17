class AddIndexToArticleTranslated < ActiveRecord::Migration[6.0] 
  def change
    execute <<-SQL
      CREATE INDEX index_translated_en ON articles ((is_translated->>'en'))
    SQL
    #add_index :articles, :is_translated, :using => :gin, :expression => "(is_translated->>'en')", :name => 'index_translated_en'
  end
end
