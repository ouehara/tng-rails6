class AddPositionToTopPageSectionsElement < ActiveRecord::Migration[6.0]
  def change
    add_column :top_page_sections_elements, :position, :integer
  end
end
