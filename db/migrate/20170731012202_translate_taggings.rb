class TranslateTaggings < ActiveRecord::Migration[6.0] 
  def change
    add_column :taggings, :lang, :string
    puts Tagging.count
    Tagging.all.each do |t|
      I18n.locale = "en"
      t.lang="en"
      t.save
      I18n.locale = "ja"
      ja = Tagging.new
      ja.article_id = t.article_id
      ja.tag_id = t.tag_id
      ja.save
      I18n.locale = "zh-hant"
      zhhant = Tagging.new
      zhhant.article_id = t.article_id
      zhhant.tag_id = t.tag_id
      zhhant.lang = "zh-hant"
      zhhant.save
      I18n.locale = "zh-hans"
      zhhans = Tagging.new
      zhhans.article_id = t.article_id
      zhhans.tag_id = t.tag_id
      zhhans.lang = "zh-hans"
      zhhans.save
      I18n.locale = "th"
      th = Tagging.new
      th.article_id = t.article_id
      th.tag_id = t.tag_id
      th.lang = "th"
      th.save
    end
  end
end
