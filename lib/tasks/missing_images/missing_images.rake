require 'csv'
namespace :missing_images do
  task :check_articles => :environment do
    t = 0
    total_articles = Article.count
    puts "[START] 記事画像チェック開始: 全#{total_articles}件"
    MissingArticlePicture.delete_all
    Article.find_each do |art|
      t += 1
      puts "[PROGRESS] #{t}/#{total_articles} - Article ID: #{art.id}" if t % 100 == 0
      check = false
      art.contents.each do |key, item|
        if item.kind_of?(String)
          break
        end
        
        if art.is_translated[key] != 'publish' && art.is_translated[key] != 'future'
          break
        end
        item.each do |i|
          #standard text
          check = checkContents(i)
          if(check)
            break
          end
        end
        if(check && !art.nil?)
          puts "[FOUND] 問題の画像を検出 - Article ID: #{art.id}, Locale: #{key}"
          mp = MissingArticlePicture.new
          mp.article = art
          mp.locale = key
          mp.save
        end
      end
    end
    puts "[COMPLETE] 処理完了: 全#{t}件の記事を処理, #{MissingArticlePicture.count}件の問題を検出"
  end

  def checkContents(i)
    check = false
    img = ImageCheck.new
    
    # デバッグログ: コンテンツタイプと構造を出力
    if i.has_key?("type")
      content_type = i['type']
      has_content = i["content"] != nil
      puts "[DEBUG] Type: #{content_type}, Has content: #{has_content}" if ENV['DEBUG_MODE'] == 'true'
    end
    
    if(i.has_key?("type") && i['type'] == "Text" && i["content"] != nil)
      check = img.parseHtml(i["content"]["text"])
      puts "[INFO] Text content checked" if ENV['DEBUG_MODE'] == 'true'
    end
    #legacy type
    if(i.has_key?("type") && i['type'] == "Legacy" && i["content"] != nil)
      if ( i["content"].kind_of?(String)) 
        content = i["content"]
      else
        content = i["content"]["text"] 
      end
      check = img.parseHtml(content)
      puts "[INFO] Legacy content checked" if ENV['DEBUG_MODE'] == 'true'
    end
    #image type
    if(i.has_key?("type") && i['type'] == "Images" && i["content"] != nil)
      c = i["content"]&.dig("src", "url")
      if c.nil?
        puts "[WARN] Images type but URL is nil. Content structure: #{i["content"].inspect}"
      else
        puts "[INFO] Checking image: #{c}" if ENV['VERBOSE_MODE'] == 'true'
        check = img.checkImgSrc(c)
        if check
          puts "[WARN] Broken image detected: #{c}"
        else
          puts "[SUCCESS] Image OK: #{c}" if ENV['VERBOSE_MODE'] == 'true'
        end
      end
    end
    check
  end


  task :check_articles_old_img => :environment do
    t = 0
    obj = []
    Article.find_each do |art|
      check = false
      art.contents.each do |key, item|
        if item.kind_of?(String)
          break
        end
        
        if art.is_translated[key] != 'publish' && art.is_translated[key] != 'future'
          break
        end
        item.each do |i|
          #standard text
          check = checkImgToOldTng(i)
          if(check)
            break
          end
        end
        if(check && !art.nil?)
          obj << {"id": art.id, "locale": key}
        end
      end
    end
    bucket = Aws::S3::Resource.new.bucket(ENV['TNG_S3_BUCKET'])
    bucket.object("feed/test.json").put(body: obj.to_json)
  end

  def checkImgToOldTng(i)
    check = false
    img = ImageCheck.new
    if(i.has_key?("type") && i['type'] == "Text" && i["content"] != nil)
      
      check = img.findImagesToOldTng(i["content"]["text"])
    end
    #legacy type
    if(i.has_key?("type") && i['type'] == "Legacy" && i["content"] != nil)
      if ( i["content"].kind_of?(String)) 
        content = i["content"]
      else
        content = i["content"]["text"] 
      end
      check = img.findImagesToOldTng(content)
    end
    #image type
    if(i.has_key?("type") && i['type'] == "Images" && i["content"] != nil)
      src = i["content"]["src"]
      c = src["url"] unless src.nil?
      check = c.include? "old.tsunagu" unless c.nil?
    end
    check
  end


  task :check_articles_insta_img => :environment do
    t = 0
    obj = []
    Article.find_each do |art|
      check = false
      art.contents.each do |key, item|
        if item.kind_of?(String)
          break
        end
        
        if art.is_translated[key] != 'publish' && art.is_translated[key] != 'future'
          break
        end
        item.each do |i|
          #standard text
          check = checkImgToInsta(i)
          if(check)
            break
          end
        end
        if(check && !art.nil?)
          obj << {"id": art.id, "locale": key}
        end
      end
    end
    bucket = Aws::S3::Resource.new.bucket(ENV['TNG_S3_BUCKET'])
    bucket.object("feed/insta.json").put(body: obj.to_json)
  end

  def checkImgToInsta(i)
    check = false
    img = ImageCheck.new
    if(i.has_key?("type") && i['type'] == "Text" && i["content"] != nil)
      
      check = img.checkIfInsta(i["content"]["text"])
    end
    #legacy type
    if(i.has_key?("type") && i['type'] == "Legacy" && i["content"] != nil)
      if ( i["content"].kind_of?(String)) 
        content = i["content"]
      else
        content = i["content"]["text"] 
      end
      check = img.checkIfInsta(content)
    end
    #image type
    if(i.has_key?("type") && i['type'] == "Images" && i["content"] != nil)
      src = i["content"]["src"]
      c = src["url"] unless src.nil?
      check = c.include? "instagram" unless c.nil?
    end
    check
  end
end