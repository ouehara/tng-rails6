# config/sitemap.rb
SitemapGenerator::Sitemap.default_host = "https://www.tsunagujapan.com" # Your Domain Name # mod SCRUM311
# SCRUM311
SitemapGenerator::Sitemap.max_sitemap_links = 50000 # default 50000
SitemapGenerator::Sitemap.compress = true # default true
SitemapGenerator::Sitemap.public_path = 'sitemap'
SitemapGenerator::Sitemap.create_index = true

# Where you want your sitemap.xml.gz file to be uploaded.
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new( 
aws_access_key_id: ENV["TNG_AWS_ACCESS_KEY_ID"],
aws_secret_access_key: ENV["TNG_AWS_SECRET_ACCESS_KEY"],
fog_provider: 'AWS',
fog_directory: ENV["TNG_S3_BUCKET"],
fog_region: ENV["TNG_AWS_S3_REGION"]
)

SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV["TNG_S3_BUCKET"]}.s3.amazonaws.com"

# sitemap.xml
opts = {
  namer: SitemapGenerator::SimpleNamer.new(:sitemap)
}
SitemapGenerator::Sitemap.create opts do
    Article.find_each do |article|
        I18n.available_locales.each do |lang|
            if article.is_translated.any?
                if article.is_translated[lang.to_s] == "publish" || article.is_translated[lang.to_s] == 'future' && article.schedule[lang.to_s] <=  Time.now.to_time.to_i
                    if(lang.to_s == "en")
                        add show_articles_path(article), :changefreq => 'daily'
                    else
                        if article.send("slug_#{lang.to_s.parameterize.underscore}")
                            add show_articles_path(lang,article.send("slug_#{lang.to_s.parameterize.underscore}")), :changefreq => 'daily'
                        else
                            add show_articles_path(lang,article.slug), :changefreq => 'daily'
                        end
                    end
                end
            end
        end
    end

    #add "en/single-page"
    #add "nl/single-page"

    # /category/feature/people-of-japan
    add category_feature_people_of_japan_path
    ["ja","zh-hant","th","vi"].each do |lang|
        add category_feature_people_of_japan_path(lang)
    end

    # /special-offer/edion/
    add "/special-offer/edion/"
    ["ja","zh-hant","zh-hans","th","vi","ko","id"].each do |lang|
        add "#{lang}/special-offer/edion/"
    end

    # /area/hokkaido/feature/
    add area_hokkaido_feature_path
    ["ja","zh-hant","zh-hans","th","vi","ko","id"].each do |lang|
        add area_hokkaido_feature_path(lang)
    end

    # /area/tohoku/feature/
    add area_tohoku_feature_path
    ["ja","zh-hant","zh-hans","th","vi","ko","id"].each do |lang|
        add area_tohoku_feature_path(lang)
    end

    # /area/kyushu/feature/
    add area_kyushu_feature_path
    ["ja","zh-hant","zh-hans","th","vi","ko","id"].each do |lang|
        add area_kyushu_feature_path(lang)
    end

    # /area/okinawa/feature/
    add area_okinawa_feature_path
    ["ja","zh-hant","zh-hans","th","vi","ko","id"].each do |lang|
        add area_okinawa_feature_path(lang)
    end

    # /area/shikoku/feature/
    add area_shikoku_feature_path
    ["ja","zh-hant","zh-hans","th","vi","ko","id"].each do |lang|
        add area_shikoku_feature_path(lang)
    end

    # /area/setouchi/feature/
    add area_setouchi_feature_path
    ["ja","zh-hant","zh-hans","th","vi","ko","id"].each do |lang|
        add area_setouchi_feature_path(lang)
    end

    # /area/kanto/feature/
    add area_kanto_feature_path
    ["ja","zh-hant","zh-hans","th","vi","ko","id"].each do |lang|
        add area_kanto_feature_path(lang)
    end

    # /area/kansai/feature/
    add area_kansai_feature_path
    ["ja","zh-hant","zh-hans","th","vi","ko","id"].each do |lang|
        add area_kansai_feature_path(lang)
    end

    # /area/chubu/feature/
    add area_chubu_feature_path
    ["ja","zh-hant","zh-hans","th","vi","ko","id"].each do |lang|
        add area_chubu_feature_path(lang)
    end

    # /area/chugoku/feature/
    add area_chugoku_feature_path
    ["ja","zh-hant","zh-hans","th","vi","ko","id"].each do |lang|
        add area_chugoku_feature_path(lang)
    end

    # /area/gunma/feature/
    add area_gunma_feature_path

    # /traveling-safely-in-japan/
    add traveling_safely_in_japan_path
    ["ja","zh-hant","zh-hans","th","vi","ko","id"].each do |lang|
        add traveling_safely_in_japan_path(lang)
    end
end

# sitemap_category.xml
category_opts = {
  include_root: false,
  namer: SitemapGenerator::SimpleNamer.new(:sitemap_category)
}
SitemapGenerator::Sitemap.create category_opts do
    Category.find_each do |cat|
        I18n.available_locales.each do |lang|
            if(lang.to_s == "en")
                add category_path(lang,cat).sub(/\/en\//, '/')
            else
                add category_path(lang,cat)
            end
        end
    end
end

# sitemap_category_listing.xml
category_listing_opts = {
  include_root: false,
  namer: SitemapGenerator::SimpleNamer.new(:sitemap_category_listing)
}
SitemapGenerator::Sitemap.create category_listing_opts do
    Category.find_each do |cat|
        Area.find_each do |area|
            I18n.available_locales.each do |lang|
                if(lang.to_s == "en")
                    add categoryListing_path(lang,cat,area).sub(/\/en\//, '/')
                else
                    add categoryListing_path(lang,cat,area)
                end
            end
        end
    end
end

# sitemap_area.xml
area_opts = {
  include_root: false,
  namer: SitemapGenerator::SimpleNamer.new(:sitemap_area)
}
SitemapGenerator::Sitemap.create area_opts do
    Area.find_each do |area|
        I18n.available_locales.each do |lang|
            if(lang.to_s == "en")
                add area_path(lang,area).sub(/\/en\//, '/')
            else
                add area_path(lang,area)
            end
        end
    end
end

#rake sitemap:refresh:no_ping