class AddMapsToCovidDetails < ActiveRecord::Migration[6.0]
  def change
    add_column :hotel_landingpages, :maps, :string
  end
end
