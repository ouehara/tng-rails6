require 'csv' 
#usage rails r ./import.rb   
JS_ESCAPE_MAP   =   { '\\' => '\\\\', '</' => '<\/', "\r\n" => '\n', "\n" => '\n', "\r" => '\n', '"' => '\\"', "'" => "\\'" }

def escape_javascript(javascript)
  if javascript
    result = javascript.gsub(/(\|<\/|\r\n|\342\200\250|\342\200\251|[\n\r"'])/u) {|match| JS_ESCAPE_MAP[match] }
  else
    ''
  end
end

#set path to csv here
csv_text = File.read('')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  l = row.to_hash
  article = Article.create
  title = l['post_title']
  titleJson = {"en": title }
  contents = {"en":[{"content"=> (l["post_content"]), "type" => "Legacy","position" =>"0", "id" => 1}]}
  excerpt = {"en": l["post_excerpt"]}
  translated = {"en":true}
  article.disp_title = titleJson  
  article.title = title
  article.contents = contents
  article.excerpt = excerpt
  article.translated = translated
  article.title_image = URI.escape(l['post_thumbnail'])
  puts article.title_image
  article.save
end