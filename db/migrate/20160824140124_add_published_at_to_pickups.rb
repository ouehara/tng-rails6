class AddPublishedAtToPickups < ActiveRecord::Migration[6.0] 
  def change
    add_column :pickups, :published_at, :datetime
  end
end
