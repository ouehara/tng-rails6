class CreateSidebarAds < ActiveRecord::Migration[6.0] 
  def change
    create_table :sidebar_ads do |t|
      t.string :label
      t.string :analytics_category
      t.string :analytics_label
      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        SidebarAd.create_translation_table! :banner_file_name => :text,
        :banner_file_size => :text,
        :banner_content_type => :text,
        :banner_updated_at => :text,
        :publish_start => :datetime,
        :publish_end => :datetime
        
      end
      dir.down do
        SidebarAd.drop_translation_table!
      end
    end
  end
end
