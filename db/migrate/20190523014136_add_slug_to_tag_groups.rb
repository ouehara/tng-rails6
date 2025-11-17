class AddSlugToTagGroups < ActiveRecord::Migration[6.0] 
  def change
    add_column :tag_groups, :slug, :string
    add_index :tag_groups, :slug, unique: true
  end
end
