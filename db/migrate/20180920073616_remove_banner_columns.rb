class RemoveBannerColumns < ActiveRecord::Migration[6.0] 
  def change
    remove_column :sidebar_ads, :banner_file_size
    remove_column :sidebar_ads, :banner_file_name
    remove_column :sidebar_ads, :banner_content_type
    remove_column :sidebar_ads, :banner_updated_at
  end
end
