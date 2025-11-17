class CreatePartner < ActiveRecord::Migration[6.0]
  def change
    create_table :partners do |t|
      t.timestamps null: false 
      t.integer :position, :null => false, :default=>0
    end
    reversible do |dir|
      dir.up do
        Partner.create_translation_table! :banner_file_name => :text,
        :banner_file_size => :text,
        :banner_content_type => :text,
        :banner_updated_at => :text,
        :title => :text,
        :link => :text
      end

      dir.down do
        Partner.drop_translation_table!
      end
    end
  end
end