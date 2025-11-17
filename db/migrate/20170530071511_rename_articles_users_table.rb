class RenameArticlesUsersTable < ActiveRecord::Migration[6.0] 
  def change
    rename_table :articles_users, :article_editors
  end
end
