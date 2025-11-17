#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "tsunagu Japan"
    xml.author "tsunagu Japan"
    xml.description "This page collects articles on things to do in Japan. It’s full of information that helps you enjoy Japan, including recommended tourist spots, places"
    xml.link "https://www.tsunagujapan.com"
    xml.language @language
    @rss.each do | a |
    a.each do |article|
      xml.item do

        if article["disp_title"]
          xml.title article.disp_title
        else
          xml.title ""
        end
        if !article.schedule.nil? && article.schedule[I18n.locale.to_s]
          xml.pubDate article.schedule[I18n.locale.to_s].to_datetime.to_s(:rfc822)
        end
        xml.language @language
        xml.media "active"
        xml.link article_url(I18n.locale,article.slug)
        xml.guid article.id
        xml.area article.cached_area.name unless article.cached_area.nil?
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