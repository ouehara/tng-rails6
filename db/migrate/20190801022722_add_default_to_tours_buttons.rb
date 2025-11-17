class AddDefaultToToursButtons < ActiveRecord::Migration[6.0] 
  def change
    change_column :tour_translations, :buttons, :jsonb, :default => []
  end
end
