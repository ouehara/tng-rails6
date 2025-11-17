class TranslateUsers < ActiveRecord::Migration[6.0] 
  def change
    reversible do |dir|
      dir.up do
        User.create_translation_table!({
          :facebook => :string,
          :instagram => :string,
          :twitter => :string,
          :google => :string,
          :pintrest => :string,
          :description => :string,
        }, {
          :migrate_data => true,
          :remove_source_columns => true
        })
      end

      dir.down do
        User.drop_translation_table! :migrate_data => true
      end
    end
  end
end
