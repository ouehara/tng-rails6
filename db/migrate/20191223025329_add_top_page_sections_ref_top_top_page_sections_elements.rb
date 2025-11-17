class AddTopPageSectionsRefTopTopPageSectionsElements < ActiveRecord::Migration[6.0]
  def change
    add_reference :top_page_sections_elements, :top_page_section, index: true
  end
end
