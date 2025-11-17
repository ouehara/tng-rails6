class CreateSavorLandmarks < ActiveRecord::Migration[6.0] 
  def change
    create_table :savor_landmarks do |t|
      t.string :pref_code
      t.string :township_code
      t.string :sub_township_code
      t.string :coordinate
      t.decimal :latitude, :precision => 10, :scale => 8
      t.decimal :longitude, :precision => 11, :scale => 8
      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        SavorLandmark.create_translation_table! :spot_name => :text,
        :outline_title => :text,
        :outline => :text,
        :access => :text,
        :address => :text
      end
    end
  end
end
