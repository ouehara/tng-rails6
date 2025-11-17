class CreateSavorMenus < ActiveRecord::Migration[6.0] 
  def change
    create_table :savor_menus do |t|
      t.belongs_to :savor_restaurant, index: true
      t.string :menu_code
      t.integer :menu_type
      t.string :carry_page
      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        SavorMenu.create_translation_table! :target => :int,
        :menu_name => :text,
        :menu_caption => :text,
        :menu_price => :text,
        :menu_photo => :text
      end
    end
  end
end
