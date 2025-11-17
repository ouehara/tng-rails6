class TranslateTags < ActiveRecord::Migration[6.0] 
  def self.up
    Tag.create_translation_table!({
      :name => :string,
    }, {
      :migrate_data => true,
      :remove_source_columns => true
    })
  end

  def self.down
    Tag.drop_translation_table! :migrate_data => true
  end
end
