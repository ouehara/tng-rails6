class AddSponsoredContentToArticle < ActiveRecord::Migration[6.0] 
  def change
    add_column :articles, :sponsored_content, :boolean
  end
end
