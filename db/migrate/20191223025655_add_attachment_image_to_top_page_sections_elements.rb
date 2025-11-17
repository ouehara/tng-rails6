class AddAttachmentImageToTopPageSectionsElements < ActiveRecord::Migration[6.0] 
  def self.up
    change_table :top_page_sections_elements do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :top_page_sections_elements, :image
  end
end
