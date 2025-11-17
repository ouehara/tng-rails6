# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

# Area data
#Area.delete_all
#CSV.foreach('db/area_data.csv') do |row|
#  I18n.locale = "en"
#  if Area.exists?(row[0])
#    a = Area.find(row[0])
#    if a.nil?

#a = Area.create(id: row[0], name: row[1], ancestry: row[2], slug: nil)
#    end
#    I18n.locale = "zh-hant"
#    a.name = row[3]
#    a.save
#    I18n.locale = "zh-hans"
#    a.name = row[4]
#    a.area_code = row[5]
#    a.prefecture_code = row[6]
#    a.save
#  end
#end
