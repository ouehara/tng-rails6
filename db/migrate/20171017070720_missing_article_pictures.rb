class MissingArticlePictures < ActiveRecord::Migration[6.0] 
  def change
    create_table :missing_article_pictures do |t|
      t.belongs_to :article, index: true
      t.string :locale
      t.timestamps
    end
  end
end
