class FixColumnTypes < ActiveRecord::Migration[6.0] 
  def change
    change_column :tour_translations, :price, :string
  end 
end
