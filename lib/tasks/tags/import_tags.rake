require 'csv'
namespace :import_tags do
  task :create_tags => :environment do
    STDOUT.puts "Clear tags? (y/n)"
    get_input
    
  end
  def get_input
    STDOUT.flush
    input = STDIN.gets.chomp
    case input.upcase
      when "Y"
        puts "deleting tags..."
        Tag.destroy_all
        continue
      when "N"
        continue
      else
        puts "Please enter Y or N"
        get_input
    end
  end 
  task :update_en => :environment do
    puts "importing tags"
    termTaxonomyText = File.read('lib/tasks/tags/tng_term_taxonomy.csv').gsub(/\\"/,'""')
    termTaxonomy = CSV.parse(termTaxonomyText, :headers => true)

    termsText = File.read('lib/tasks/tags/tng_terms.csv').gsub(/\\"/,'""')
    terms = CSV.parse(termsText, :headers => true)
    termTaxonomy.each do |row|
      termTax = row.to_hash
      next if row["taxonomy"] != "post_tag"
      terms.each do |term|
        next if row['term_id'] != term['term_id']
        if (Tag.exists?(row['term_id']))
          tag = Tag.find(row["term_id"])
          I18n.locale = :en
          tag.name = term['english']
          tag.save
        end
      end
    end
  end
  def continue
    puts "importing tags"
    CSV.foreach('lib/tasks/tags/new.csv', headers: true) do |row|
      if(row['name_en'].nil?)
        I18n.locale= :ja
      else
        I18n.locale= :en        
      end
      t = Tag.find_or_create_by(id: row['id'])
      t.id = row['id']
      t.name_ja = row['name_ja'] unless row['name_ja'].nil?
      t.name_en = row['name_en'] unless row['name_en'].nil?
      t.name_zh_hant = row['name_zh_hant'] unless row['name_zh_hant'].nil?
      t.name_zh_hans = row['name_zh_hans'] unless row['name_zh_hans'].nil?
      t.name_ja = row['name_ja'] unless row['name_ja'].nil?
      t.name_th = row['name_th'] unless row['name_th'].nil?
      t.name_ko = row['name_ko'] unless row['name_ko'].nil?
      t.name_vi = row['name_vi'] unless row['name_vi'].nil?
      t.save
    end
  end
  task :addTranslation => :environment do
    CSV.foreach('lib/tasks/tags/updateLang.csv', headers: true) do |row|
      t = Tag.find_or_create_by(id: row['id'])
      t.id = row['id']
      t.name_id = row['name_id'] unless row['name_id'].nil?
      t.save
    end
  end
  task :tag_group => :environment do
    TagGroupToArticle.delete_all
    TagGroup.delete_all
    CSV.foreach('lib/tasks/tags/groups.csv', headers: true) do |row|
      TagGroup.create(row.to_h)
      t = TagGroup.find_or_create_by(name: row['name_en'])
      t.name_ja = row['name_ja'] unless row['name_ja'].nil?
      t.name_en = row['name_en'] unless row['name_en'].nil?
      t.name_zh_hant = row['name_zh_hant'] unless row['name_zh_hant'].nil?
      t.name_zh_hans = row['name_zh_hans'] unless row['name_zh_hans'].nil?
      t.name_th = row['name_th'] unless row['name_th'].nil?
      t.name_ko = row['name_ko'] unless row['name_ko'].nil?
      t.name_vi = row['name_vi'] unless row['name_vi'].nil?
      t.save
    end
  end

  task :tag_group_article => :environment do
      CSV.foreach('lib/tasks/tags/groups_article.csv', headers: true) do |row|
        TagGroupToArticle.create(row.to_h)
      end
  end

  task :taggings => :environment do
    CSV.foreach('lib/tasks/tags/taggings.csv', headers: true) do |row|
      I18n.locale=row['lang']
      t = Tag.find(row['tag_id']) unless row['tag_id'].nil?
      if !row['tag_id'].nil? && t.translated_locales.include?(row['lang'].to_sym)
        Tagging.create(row.to_h)
      end
    end
  end

end 