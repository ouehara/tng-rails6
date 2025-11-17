namespace :add_article_cloudsearch do
  desc "add article to cloudsearch"
  task :add_index, [:article_id] => :environment do |task, args|
    article_id = args[:article_id].to_i
    article = Article.find(article_id)
    article.delete_index
    article.add_to_index_sanitized
  end
end
