class MapsToTranslation < ActiveRecord::Migration[6.0]
  def change
    HotelLandingpage.add_translation_fields!({ :maps => :string,
    },{
          :migrate_data => true,
          :remove_source_columns => true
        })
  end
end
