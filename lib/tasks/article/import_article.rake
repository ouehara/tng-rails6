require 'csv'
namespace :import_article do
  task :update => :environment do
    puts "importing articles"
    CSV.foreach("lib/tasks/article/cat.csv", headers: true) do |row|
      t = Article.where(id: row['id'])
      t.update(row.to_hash) unless t.nil?
    end
  end
  
  task :create_article => :environment do
    translationsFile = File.read('lib/tasks/article/tng_icl_translations.csv')#.gsub(/\\"/,'""')
    translations = CSV.parse(translationsFile, :headers => true)

    postsFile = File.read('lib/tasks/article/posts.csv').gsub(/\\"/,'""')
    posts = CSV.parse(postsFile, :headers => true);

    #tagsFile = File.read('lib/tasks/article/tags_to_article.csv')#.gsub(/\\"/,'""')
    #tags = CSV.parse(tagsFile, :headers => true)

    translations.each do |row|
      translation = row.to_hash
      next if (translation["element_type"] != "post_post")
      
      posts.each do |post|
        l = post.to_hash
        #puts  "#{translation['element_id']}:::#{l['ID']}"
        
        next if translation['element_id'] != l['ID']
        language_code = translation['language_code']
        title = l['post_title']
        titleJson = {"#{language_code}": title }
        contents = {"#{language_code}":[{"content"=> (l["post_content"]), "type" => "Legacy","position" =>"0", "id" => 1}]}
        excerpt = {"#{language_code}": l["post_excerpt"]}
        translated = {"#{language_code}":l["post_status"]}
        future = {"#{language_code}": l['post_date']}
        if l["post_status"] == "future"
        puts "future"
        puts translation['trid']
        end
       # suppress(Exception) do
        if Article.exists?(translation['trid'])
          puts 'article exits'
          article = Article.find(translation['trid'])
          article.disp_title = article.disp_title.merge(titleJson)
          if translation["language_code"] == "en"
            article.title = title
            #if(l['post_name'] != "")
            #  article.slug = l['post_name']
            #else
            #  article.slug = nil
            #end
            article.user_id = l['post_author']
            if(l['thumbnail_url'] != "NULL")
              suppress(Exception) do
              uri = URI.parse( URI.encode(l['thumbnail_url']))
              uri.scheme = "https"
              uri.to_s
              article.title_image = uri
              end
            end
            #if(article.tags == nil)
            #  tags.each do |row|
            #    t = row.to_hash
            #    next if t['object_id'] != l["ID"]
            #    next if !Tag.exists?(t['term_taxonomy_id'])
            #    article.tags << Tag.find(t['term_taxonomy_id'])
            #  end
            #end
          end
          if(!article.title_image.exists?)
            suppress(Exception) do
              uri = URI.parse( URI.encode(l['thumbnail_url']))
              uri.scheme = "https"
              uri.to_s
              article.title_image = uri
              end
          end
          article.contents = article.contents.merge(contents)
          article.excerpt = article.excerpt.merge(excerpt)
          article.is_translated = article.is_translated.merge(translated)
          if future != nil 
            if(article.schedule == nil)
              article.schedule = {}
            end
            article.schedule = article.schedule.merge(future)
          end
          puts "---------"
          puts l['post_name']
          puts translation["language_code"]
          I18n.locale = translation["language_code"];
          article.slug = l['post_name']
          article.title = title
          #article.set_friendly_id(l['post_name'],translation["language_code"])
          article.save
          
          break;
        else
          puts l['post_date']
          article = Article.new
          article.id = translation['trid']
          article.disp_title = titleJson  
          if future != nil 
            article.schedule = future
          end
          article.title = title
          article.contents = contents
          article.excerpt = excerpt
          article.user_id = l['post_author']
          article.is_translated = translated
          article.created_at = l['post_date']
          article.published_at = l['post_date']
          article.updated_at = l['post_modified']
          #if(l['post_name'] != "")
          #  article.slug = l['post_name']
          #else
          #  article.slug = nil
          #end
          if(l['thumbnail_url'] != "NULL")
            suppress(Exception) do
            uri = URI.parse( URI.encode(l['thumbnail_url']))
            uri.scheme = "https"
            uri.to_s
            article.title_image = uri
            end
          end
          I18n.locale = translation["language_code"];
          article.slug = l['post_name']
          article.title = title
          article.save
          
          puts Article.exists?(translation['trid']) 
          #if translation["language_code"] == "en"
          #  tags.each do |row|
          #    t = row.to_hash
          #    next if t['object_id'] != l["ID"]
          #    next if !Tag.exists?(t['term_taxonomy_id'])
          #    article.tags << Tag.find(t['term_taxonomy_id'])
          #  end
          #end
          break;
          end
       # end
      end
    end
  end

  task :tags_to_article => :environment do
    tagsFile = File.read('lib/tasks/article/tags_to_article.csv')#.gsub(/\\"/,'""')
    tags = CSV.parse(tagsFile, :headers => true)
    tags.each do |row|
      t = row.to_hash
      next if !Article.exists?(t['object_id'])
      next if !Tag.exists?(t['term_taxonomy_id'])
      art =  Article.find(t['object_id'])
      art.tags << Tag.find(t['term_taxonomy_id'])
    end
  end
end