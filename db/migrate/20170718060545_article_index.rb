class ArticleIndex < ActiveRecord::Migration[6.0] 
  def change
    execute <<-SQL
      CREATE INDEX is_translated_en ON articles ((is_translated->>'en'),(schedule->>'en'));
      CREATE INDEX is_translated_hant ON articles ((is_translated->>'zh-hant'),(schedule->>'zh-hant'));
      CREATE INDEX is_translated_hans ON articles ((is_translated->>'zh-hans'),(schedule->>'zh-hans'));
      CREATE INDEX is_translated_ja ON articles ((is_translated->>'ja'),(schedule->>'ja'));
      CREATE INDEX is_translated_th ON articles ((is_translated->>'th'),(schedule->>'th'));
    SQL
  end
end
