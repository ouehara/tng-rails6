class TagToCatRedirect < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_to_cats do |t|
      t.timestamps
      t.string :slug
      t.references :category
    end
  end
end
