class ChangeDataTypeForArticlesExcerpt < ActiveRecord::Migration[6.0] 
  def change
    Article.find_each do |art| 
      art.excerpt = '{"en": "#{art.excerpt}"}'
      art.save
    end 
    change_column :articles, :excerpt, 'jsonb USING CAST(excerpt AS jsonb)'
  end
end
