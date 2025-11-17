class AtLangToArticleEditor < ActiveRecord::Migration[6.0] 
  def change
    add_column :article_editors, :lang, :string
  end
end
