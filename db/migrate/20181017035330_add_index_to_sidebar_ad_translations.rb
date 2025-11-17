class AddIndexToSidebarAdTranslations < ActiveRecord::Migration[6.0] 
  def change
    add_index :sidebar_ad_translations, [:publish_start, :publish_end]
  end
end
