class CreateSavorRestaurants < ActiveRecord::Migration[6.0] 
  def change
    create_table :savor_restaurants do |t|
      t.string :restaurant_code
      t.string :jp_name
      t.string :restaurant_type_class_cd
      t.string :restaurant_type_cd
      t.string :tel
      t.integer :average_price_lunch
      t.integer :average_price_grand
      t.string :coordinate
      t.decimal :lat
      t.decimal :lng
      t.integer :internet_available
      t.integer :free_wifi_available
      t.integer :mobile_connectable
      t.integer :separation_of_smoking
      t.integer :no_smoking
      t.integer :smoking_available
      t.integer :course_menu
      t.integer :large_cocktail_selection
      t.integer :large_shochu_selection
      t.integer :large_sake_selection
      t.integer :large_wine_selection
      t.integer :all_you_can_eat
      t.integer :all_you_can_drink
      t.integer :lunch_menu
      t.integer :take_out
      t.integer :coupon
      t.integer :small_groups
      t.integer :delivery
      t.integer :kids_menu
      t.integer :special_diet
      t.integer :food_allergy
      t.integer :vegetarian_menu
      t.integer :halal_menu
      t.integer :breakfast
      t.integer :imported_beer
      t.integer :reservation
      t.integer :room_reservation
      t.integer :storewide_reservation
      t.integer :late_night_service
      t.integer :child_friendly
      t.integer :pet_friendly
      t.integer :private_room
      t.integer :tatami_room
      t.integer :kotatsu
      t.integer :parking
      t.integer :barrier_free
      t.integer :sommelier
      t.integer :terrace
      t.integer :live_show
      t.integer :entertainment_facilities
      t.integer :karaoke
      t.integer :band_playable
      t.integer :tv_projector
      t.integer :seats_10
      t.integer :seats_20
      t.integer :seats_30
      t.integer :seats_over_30
      t.integer :membership
      t.integer :jacuzzi
      t.integer :vip_room
      t.integer :donated
      t.integer :donation_box
      t.integer :power_saving
      t.integer :western_cutlery
      t.integer :counter_seats
      t.integer :card_accepted
      t.integer :card_accept_amex
      t.integer :card_accept_diners
      t.integer :card_accept_master
      t.integer :card_accept_visa
      t.integer :card_accept_unionpay
      t.integer :electronic_money
      t.integer :facebook_pages

      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        SavorRestaurant.create_translation_table! :target => :integer, 
        :information_photo => :text,
        :search_result_photo => :text,
        :name => :text,
        :station_1 => :text,
        :station_2 => :text,
        :directions => :text,
        :catch_copy_title => :text,
        :catch_copy => :text,
        :open => :text,
        :holiday => :text,
        :address => :text,
        :menu => :text,
        :languages_available => :integer

      end

      dir.down do
        SavorRestaurants.drop_translation_table!
      end
    end
  end
end
