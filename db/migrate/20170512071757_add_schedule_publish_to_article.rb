class AddSchedulePublishToArticle < ActiveRecord::Migration[6.0] 
  def change
    add_column :articles, :schedule, :jsonb
  end
end
