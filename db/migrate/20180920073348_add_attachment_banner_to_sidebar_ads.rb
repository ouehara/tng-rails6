class AddAttachmentBannerToSidebarAds < ActiveRecord::Migration[6.0] 
  def self.up
    change_table :sidebar_ads do |t|
      t.attachment :banner
    end
  end

  def self.down
    remove_attachment :sidebar_ads, :banner
  end
end
