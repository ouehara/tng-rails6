class Rssfeed < ActiveRecord::Migration[6.0] 
  def change
    create_table :rss_feeds do |t|
      t.timestamps null: false 
      t.references :article,  foreign_key: true
      t.string :locale
      t.integer :action
    end
  end
end
