class AddUserToVideos < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        Video.add_translation_fields! user: :text
      end

      dir.down do
        remove_column :video_translations, :user
      end
    end
  end
end
