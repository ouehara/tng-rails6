require 'nokogiri'

include Rails.application.routes.url_helpers
namespace :xml do
    task :articles, [:lang] => :environment do |task, args|
        ids = RssFeed.blacklist.map(&:article_id)
        promote = RssFeed.promote.map(&:article_id)
        imp = ImpressionsAdapter.new
        jnto_categories = {2=> "J042", 1=> "J041", 3=> "J042", 4=> "J043", 5=> "J043", 6=> "J043"}
        jnto_area= {"hokkaido"=> "J001", "tohoku"=> "J002", 
        "kanto"=> "J003", "tokyo"=> "J004", "chubu"=> "J005", "kansai"=> "J006",
        "chugoku"=> "J007", "shikoku"=> "J008", "kyushu"=> "J009", "okinawa"=> "J009", "nationwide"=> "J004", "others"=> "J004"}
        most_viewed = imp.getMostViewed
        most_viewed_id = {"th" => [], "en" => [], 'zh-hant'=> [], 'zh-hans'=>[]}
        impressions = {"th" => [], "en" => [], 'zh-hant'=> [], 'zh-hans'=>[]}
        most_viewed.Items.each do |mv|
            most_viewed_id[mv.Language] += [mv.ElementId]
            impressions[mv.Language][mv.ElementId ] = mv.Count
        end
	builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8')  do |xml|
                xml.rss("version" => '2.0') do |rss|
                xml.channel do
                    xml.title "tsunagu Japan"
                    xml.author "tsunagu Japan"
                    xml.description "This page collects articles on things to do in Japan. It’s full of information that helps you enjoy Japan, including recommended tourist spots, places"
                    xml.link "https://www.tsunagujapan.com"
            most_viewed_id.each do |val|
                I18n.locale = val[0]
                @rss = Article.translation_published(val[0]).
                includes(:translations).where(articles: {id: val[1]})
                puts @rss.inspect
            #@rss += Article.translation_published_simple(index).where(id: promote)
                    @rss.each do |article|
                        puts article
                        impression_count = impressions[val[0]][article.id]

                        xml.item do
                            if article["disp_title"]
                                xml.title article.disp_title
                            else
                                xml.title ""
                            end
                            if !article.lang_updated_at.nil? && article.lang_updated_at[val[0]]
                                xml.pubDate article.lang_updated_at[val[0]].to_datetime.to_s(:rfc822)
                            end
                            xml.lastPubDate DateTime.now.to_s(:rfc822)
                            xml.author !article.cached_users.nil? ? article.cached_users.username : ""
                            xml.language val[0]
                            xml.media "active"
                            xml.link article_url(val[0],article.slug)
                            xml.guid article.id
                            
                            if(!article.cached_area.nil?)
                                if(article.cached_area.slug.downcase == "tokyo" || article.cached_area.slug.downcase == "okinawa")
                                    xml.exArea jnto_area[article.cached_area.slug]
                                else
                                    xml.exArea jnto_area[article.cached_area.root.slug]
                                end
                            end
                            xml.exCategory jnto_categories[article.cached_category.id] unless article.cached_category.nil?
                            xml.viewCount impression_count
                            xml.area article.cached_area.name unless article.cached_area.nil?
                            xml.category article.cached_category.name unless article.cached_category.nil?
                            text = article.excerpt
                                # if you like, do something with your content text here e.g. insert image tags.
                                # Optional. I'm doing this on my website.
                            image_url = article.title_image(:original)
                            image_tag = "
                                <img src='" + image_url +  "' />
                            "
                            text = text.sub('{image}', image_tag)
                            xml.description {xml.cdata!  (image_tag + text) }
                            xml.enclosure url: article.title_image(:original), type:"image/jpeg" 
                            xml.image url: article.title_image(:original), type:"image/jpeg"
                            end
                        end
                    end
                end
            end
        end
        bucket = Aws::S3::Resource.new.bucket(ENV['TNG_S3_BUCKET'])
        bucket.object("feed/top-articles.xml").put(body: builder.to_xml)
    end

    task :wowjapan, [:lang] => :environment do |task, args|
        jnto_categories = {2=> "sightseeing", 1=> "food", 3=> "hotels", 4=> "shopping", 5=> "tips_manners", 6=> "tips_manners"}
        lngKeys = {"zh-hant"=>"tw", "zh-hans"=>"cn", "ko" => "kr"}
        ["en","zh-hant"].each do |lang|
        I18n.locale = lang
        
	builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8')  do |xml|
                xml.rss("version" => '2.0') do |rss|
                xml.channel do
                    xml.title "tsunagu Japan"
                    xml.author "tsunagu Japan"
                    xml.description "This page collects articles on things to do in Japan. It’s full of information that helps you enjoy Japan, including recommended tourist spots, places"
                    xml.link "https://www.tsunagujapan.com"
                    puts "lib/tasks/xml/#{lang}.csv"
                    CSV.foreach("lib/tasks/xml/#{lang}.csv", headers: false) do |row|
                        article = Article.translation_published(lang).friendly.find(row[0])
                        xml.item do
                            if article["disp_title"]
                                xml.title article.disp_title
                            else
                                xml.title ""
                            end
                            if !article.lang_updated_at.nil? && article.lang_updated_at[lang]
                                xml.pubDate article.lang_updated_at[lang].to_datetime.to_s(:rfc822)
                            end
                            xml.author !article.cached_users.nil? ? article.cached_users.username : ""
                            xml.lang lngKeys.key?(lang.to_s) ? lngKeys[lang.to_s] : lang
                            xml.media "active"
                            xml.link lang.to_s == "en" ? article_url(nil,article.slug) : article_url(lang,article.slug)
                            xml.guid article.id
                            xml.mainId article.id

                            xml.area article.cached_area.nil? ? "other" : getArea(article.cached_area)
                            xml.genre jnto_categories[article.cached_category.root.id] unless article.cached_category.root.nil?
                            text = article.excerpt
                            
                            xml.description text
                            xml.enclosure img: article.title_image(:original)+"&d=750x400", type:"image/jpeg" 
                            xml.image url: article.title_image(:original), type:"image/jpeg"
                            if article.all_tags != ""
                                xml.keywords article.all_tags.gsub(/\s+/, '')
                            end
                                
                                art_url = lang.to_s == "en" ? article_url(nil,article.slug) : article_url(lang,article.slug)
                                #art_url = "https://www.tsunagujapan.com/9train-tokyo-mystery-circus-shinjuku/"
                            
                                html =   Nokogiri::HTML(open("https://5z2v10n5q2.execute-api.ap-northeast-1.amazonaws.com/prod?url="+art_url),nil,  Encoding::UTF_8.to_s)
                                h = html.css('.blog-entry')
                                xml.encoded {xml.cdata (h) }
                                related1 = Article.translation_published(lang).friendly.find(row[1])
                                related2 = Article.translation_published(lang).friendly.find(row[2])
                                related3 = Article.translation_published(lang).friendly.find(row[3])
                            xml.relatedLink title: related1.disp_title, thumbnail: related1.title_image(:original)+"&d=750x400", link: lang.to_s == "en" ? article_url(nil,related1.slug) : article_url(lang,related1.slug)
                            xml.relatedLink title: related2.disp_title, thumbnail: related2.title_image(:original)+"&d=750x400", link: lang.to_s == "en" ? article_url(nil,related2.slug) : article_url(lang,related2.slug)
                            xml.relatedLink title: related3.disp_title, thumbnail: related3.title_image(:original)+"&d=750x400", link: lang.to_s == "en" ? article_url(nil,related3.slug) : article_url(lang,related3.slug)
                            end
                        end
                    end
                end
            
        end
        puts "done"
        bucket = Aws::S3::Resource.new.bucket(ENV['TNG_S3_BUCKET'])
        bucket.object("feed/#{lang}-feed.xml").put(body: builder.to_xml, content_type: "text/xml")
    end
    end

    def getArea(area)
        areas = ["hokkaido", "iwate", "tokyo", "kanagawa", "hiroshima", "kagawa", "fukuoka", "nagasaki", "kumamoto", "okinawa",
        "tohoku", "kanto", "koshinetsu", "hokuriku", "nagano", "shizuoka", "kyoto", "osaka",
        "hyogo", "nara", "tokai", "kansai", "chugoku", "shikoku", "shikoku", "sendai", "kanazawa", "nagoya", "other"]
        if area.is_root? && !areas.include?(area.name.downcase)
            return "other"
        end
        if(areas.include?(area.name.downcase)) 
            return area.name.downcase
        end
        getArea(area.parent)
    end
end