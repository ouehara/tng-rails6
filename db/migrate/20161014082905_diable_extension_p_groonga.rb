class DiableExtensionPGroonga < ActiveRecord::Migration[6.0] 
  def change
    unless Rails.env.staging? or Rails.env.production?
      disable_extension 'pgroonga'
    end
  end
end
