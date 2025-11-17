require 'csv'
namespace :category do
    task :import_cat3 => :environment do
        CSV.foreach('lib/tasks/category/cat3.csv', headers: true) do |row|
              I18n.locale= :en        
            t = Category.new
            t.name = row['name']
            t.parent_id =  row['parent_id']
            t.save
          end
    end
end