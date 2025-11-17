class CreateSavorCoupons < ActiveRecord::Migration[6.0] 
  def change
    create_table :savor_coupons do |t|
      t.belongs_to :savor_restaurant, index: true
      t.string :coupon_code
      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        SavorCoupon.create_translation_table! :target => :int,
        :coupon_title => :text,
        :coupon_description => :text,
        :coupon_available_from => :date,
        :coupon_available_to => :date,
        :coupon_publish_from => :date,
        :coupon_publish_to => :date
      end
    end
  end
end
