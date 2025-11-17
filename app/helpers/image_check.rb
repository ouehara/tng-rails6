require 'nokogiri'
require 'cgi'
require 'uri'

class ImageCheck
  def parseHtml(html)
    doc = Nokogiri::HTML(html)
    foundBrokenImage = false
    doc.css("img").each do |l|
      if l.attr("src").include? "old.tsunagu"
        break
      end
      foundBrokenImage = self.checkImgSrc(l.attr("src"))
      if foundBrokenImage
        break
      end
    end
    return foundBrokenImage
  end


  def checkIfInsta(html)
    doc = Nokogiri::HTML(html)
    doc.css("img").each do |l|
      if l.attr("src").include? "instagram"
        return true
      end     
    end
    return false
  end
  def findImagesToOldTng(html)
    doc = Nokogiri::HTML(html)
    doc.css("img").each do |l|
      if l.attr("src").include? "old.tsunagu"
        return true
      end     
    end
    return false
  end

  def checkImgSrc(url)
    return false if url.nil? || url.to_s.strip.empty?
    
    # URLを適切にエンコード
    begin
      # 非ASCII文字が含まれている場合は最初からエンコード
      url_to_parse = url.strip
      if url_to_parse =~ /[^\x00-\x7F]/
        url_to_parse = encode_url(url_to_parse)
        uri = URI.parse(url_to_parse)
      else
        uri = URI.parse(url_to_parse)
      end
    rescue => e
      puts "[ERROR] URI parse failed: #{url} - #{e.message}"
      return false
    end
    
    return false if uri.nil?
    
    if uri.kind_of?(URI::HTTP) or uri.kind_of?(URI::HTTPS)
      begin
        res = Net::HTTP.get_response(uri)
        if res.code.to_i > 399
          puts "[ERROR] Image not accessible (#{res.code}): #{url}"
          return true
        else
          puts "[SUCCESS] Image accessible (#{res.code}): #{url}" if ENV['VERBOSE_MODE'] == 'true'
          return false
        end
      rescue => e
        puts "[ERROR] HTTP request failed: #{url} - #{e.message}"
        return true
      end
    end      
    return false
  end
  
  private
  
  def encode_url(url)
    # URLを分解してパス部分だけをエンコード
    # 非ASCII文字をパーセントエンコード
    url.gsub(/[^\x00-\x7F]/) { |char| CGI.escape(char) }
  end
end