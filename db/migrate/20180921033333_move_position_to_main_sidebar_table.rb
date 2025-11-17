class MovePositionToMainSidebarTable < ActiveRecord::Migration[6.0] 
  def change
    #remove_column :sidebar_ad_translations, :position
    #add_column :sidebar_ads, :position, :int
  end
end
