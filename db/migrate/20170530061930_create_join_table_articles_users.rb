class CreateJoinTableArticlesUsers < ActiveRecord::Migration[6.0] 
  def change
    create_table :articles_users, id: false do |t|
      t.belongs_to :articles
      t.belongs_to :users
      t.timestamps null: false 
    end
  end
end
