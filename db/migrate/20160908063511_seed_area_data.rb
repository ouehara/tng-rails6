require 'csv'
class SeedAreaData < ActiveRecord::Migration[6.0] 
  def up
    #Area.delete_all
    #CSV.foreach('db/area_data.csv') do |row|
    #  Area.create(id: row[0], name: row[1], ancestry: row[2])
    #end
  end
end
