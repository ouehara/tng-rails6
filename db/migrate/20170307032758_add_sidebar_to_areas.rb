class AddSidebarToAreas < ActiveRecord::Migration[6.0] 
  def change
    add_column :areas, :in_sidebar, :bool
  end
end
