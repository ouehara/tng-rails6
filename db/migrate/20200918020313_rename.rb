class Rename < ActiveRecord::Migration[6.0]
  def change
    rename_column :top_page_section_translations, :display, :selected_template
  end
end
