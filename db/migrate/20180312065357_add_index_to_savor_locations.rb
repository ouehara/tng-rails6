class AddIndexToSavorLocations < ActiveRecord::Migration[6.0] 
  def change
    add_index :savor_location_translations, :pref
    add_index :savor_location_translations, :township
    add_index :savor_location_translations, :sub_township

    add_index :savor_landmark_translations, :spot_name

  end
end
