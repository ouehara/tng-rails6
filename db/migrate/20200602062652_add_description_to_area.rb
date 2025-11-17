class AddDescriptionToArea < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        Area.add_translation_fields! description: :text
      end

      dir.down do
        remove_column :area_translations, :description
      end
    end
  end
end
