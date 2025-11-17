class CreateTours < ActiveRecord::Migration[6.0] 
  def change
    create_table :tours do |t|
      t.timestamps null: false 
      t.references :area, index: true, foreign_key: true
    end
    reversible do |dir|
      dir.up do
        Tour.create_translation_table! :banner_file_name => :text,
        :banner_file_size => :text,
        :banner_content_type => :text,
        :banner_updated_at => :text,
        :title => :text,
        :details => :text,
        :price => :integer,
        :duration => :text,
        :buttons => :jsonb

      end

      dir.down do
        Tour.drop_translation_table!
      end
    end
  end
end
