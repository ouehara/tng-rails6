class CreateVideo < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.timestamps null: false 
      t.integer :position, :null => false, :default=>0
    end
    reversible do |dir|
      dir.up do
        Video.create_translation_table! :title => :text,
        :link => :text
      end

      dir.down do
        Video.drop_translation_table!
      end
    end
  end
end
