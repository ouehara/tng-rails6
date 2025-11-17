class CreateSavorLocations < ActiveRecord::Migration[6.0] 
  def change
    create_table :savor_locations do |t|
      t.string :pref_code
      t.string :township_code
      t.string :sub_township_code
      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        SavorLocation.create_translation_table! :pref => :text,
        :township => :text,
        :sub_township => :text
      end
    end
  end
end
