class AddCssClassToCategory < ActiveRecord::Migration[6.0] 
  def change
    add_column :categories, :css_class, :string
  end
end
