class AddUrlToSidebarAds < ActiveRecord::Migration[6.0] 
  def change
    reversible do |dir|
      dir.up do
        SidebarAd.add_translation_fields! url: :text
      end

      dir.down do
        remove_column :sidebar_ad_translations, :url
      end
    end
  end
end
