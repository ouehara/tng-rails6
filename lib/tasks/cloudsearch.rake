namespace :cloudsearch do
  desc "Refresh all cloudsearch index"
  task refresh_index: :environment do
    Article.find_each do |article|
      article.delete_index
    end

    Article.update_all_index
  end
end
