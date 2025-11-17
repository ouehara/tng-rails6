class RemoveUserColumnFromArticle < ActiveRecord::Migration[6.0] 
  def change
    Article.all.each do |a|
      ArticleUser.create!(:user_id => a.user_id, :article_id => a.id, :lang => "en");
      ArticleUser.create!(:user_id => a.user_id, :article_id => a.id, :lang => "zh-hant");
      ArticleUser.create!(:user_id => a.user_id, :article_id => a.id, :lang => "zh-hans");
      ArticleUser.create!(:user_id => a.user_id, :article_id => a.id, :lang => "ja");
    end
    remove_column :articles, :user_id
  end
end
