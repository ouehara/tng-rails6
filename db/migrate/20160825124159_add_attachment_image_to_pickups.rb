class AddAttachmentImageToPickups < ActiveRecord::Migration[6.0] 
  def self.up
    change_table :pickups do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :pickups, :image
  end
end
