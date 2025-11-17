class CreateArticles < ActiveRecord::Migration[6.0] 
  def change
    create_table :articles do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :title
      t.text :excerpt
      t.string :slug
      t.jsonb :contents, null: false, default: '[]'

      t.timestamps null: false
    end
    add_index :articles, :slug, unique: true
  end
end
