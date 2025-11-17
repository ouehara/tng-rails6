class CopyArticleUsersToTranslators < ActiveRecord::Migration[6.0] 
  def change
    ArticleUser.all.each do |a|
      b = ArticleTranslator.new(a.attributes);
      b.save
    end
  end
end
