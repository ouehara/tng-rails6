class AddIndexToHotelName < ActiveRecord::Migration[6.0] 
  def change
    execute <<-SQL
      CREATE INDEX idx_fts_name ON hotels USING gin(to_tsvector('english', name))
    SQL
  end
end
