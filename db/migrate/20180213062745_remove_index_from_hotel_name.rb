class RemoveIndexFromHotelName < ActiveRecord::Migration[6.0] 
  def change
    remove_index "hotels", name: "idx_fts_name"

  end
end
