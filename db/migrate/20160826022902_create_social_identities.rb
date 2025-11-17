class CreateSocialIdentities < ActiveRecord::Migration[6.0] 
  def change
    create_table :social_identities do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :name
      t.string :nickname
      t.string :email
      t.string :url
      t.string :image_url
      t.string :description
      t.text :others
      t.text :credentials
      t.text :raw_info

      t.timestamps null: false
    end
  end
end
