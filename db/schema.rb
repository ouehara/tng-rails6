# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_04_152332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "area_translations", force: :cascade do |t|
    t.bigint "area_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.text "description"
    t.index ["area_id"], name: "index_area_translations_on_area_id"
    t.index ["locale"], name: "index_area_translations_on_locale"
  end

  create_table "areas", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.string "slug"
    t.boolean "in_sidebar"
    t.integer "area_code"
    t.integer "prefecture_code"
    t.string "names_depth_cache"
    t.integer "pos"
    t.integer "map_position"
    t.index ["ancestry"], name: "index_areas_on_ancestry"
    t.index ["slug"], name: "index_areas_on_slug", unique: true
  end

  create_table "article_editors", force: :cascade do |t|
    t.bigint "articles_id"
    t.bigint "users_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "lang"
    t.index ["articles_id"], name: "index_article_editors_on_articles_id"
    t.index ["users_id"], name: "index_article_editors_on_users_id"
  end

  create_table "article_group_translations", force: :cascade do |t|
    t.bigint "article_group_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.index ["article_group_id"], name: "index_article_group_translations_on_article_group_id"
    t.index ["locale"], name: "index_article_group_translations_on_locale"
  end

  create_table "article_grouping_favorites", force: :cascade do |t|
    t.integer "group_1"
    t.integer "group_2"
    t.integer "group_3"
    t.integer "group_4"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "article_groupings", id: false, force: :cascade do |t|
    t.bigint "article_id"
    t.bigint "article_group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_group_id"], name: "index_article_groupings_on_article_group_id"
    t.index ["article_id"], name: "index_article_groupings_on_article_id"
  end

  create_table "article_groups", force: :cascade do |t|
    t.string "ancestry"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "names_depth_cache"
    t.integer "pos"
    t.index ["ancestry"], name: "index_article_groups_on_ancestry"
  end

  create_table "article_translations", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "slug"
    t.text "title"
    t.text "title_image_file_name"
    t.text "title_image_file_size"
    t.text "title_image_content_type"
    t.text "title_image_updated_at"
    t.text "canonical"
    t.index ["article_id"], name: "index_article_translations_on_article_id"
    t.index ["locale"], name: "index_article_translations_on_locale"
    t.index ["slug", "locale"], name: "index_article_translations_on_slug_and_locale"
    t.index ["slug"], name: "index_article_translations_on_slug"
  end

  create_table "article_translators", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "article_id"
    t.string "lang"
    t.index ["article_id"], name: "index_article_translators_on_article_id"
    t.index ["user_id"], name: "index_article_translators_on_user_id"
  end

  create_table "article_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "article_id"
    t.string "lang"
    t.index ["article_id", "lang"], name: "index_article_users_on_article_id_and_lang", unique: true
    t.index ["article_id"], name: "index_article_users_on_article_id"
    t.index ["user_id"], name: "index_article_users_on_user_id"
  end

  create_table "articles", force: :cascade do |t|
    t.jsonb "excerpt"
    t.jsonb "contents", default: "[]", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "category_id"
    t.datetime "published_at"
    t.integer "impressions_count", default: 0
    t.jsonb "is_translated", default: {"en"=>false}
    t.bigint "area_id"
    t.jsonb "disp_title"
    t.boolean "sponsored_content"
    t.jsonb "schedule"
    t.string "slug"
    t.jsonb "lang_updated_at"
    t.jsonb "optimistic_lock", default: {"en"=>1, "ja"=>1, "th"=>1, "zh-hans"=>1, "zh-hant"=>1}, null: false
    t.boolean "unlist", default: false
    t.integer "template", default: 1
    t.index "((is_translated ->> 'en'::text))", name: "index_translated_en"
    t.index "((is_translated ->> 'en'::text)), ((schedule ->> 'en'::text))", name: "is_translated_en"
    t.index "((is_translated ->> 'ja'::text)), ((schedule ->> 'ja'::text))", name: "is_translated_ja"
    t.index "((is_translated ->> 'th'::text)), ((schedule ->> 'th'::text))", name: "is_translated_th"
    t.index "((is_translated ->> 'zh-hans'::text)), ((schedule ->> 'zh-hans'::text))", name: "is_translated_hans"
    t.index "((is_translated ->> 'zh-hant'::text)), ((schedule ->> 'zh-hant'::text))", name: "is_translated_hant"
    t.index ["area_id"], name: "index_articles_on_area_id"
    t.index ["category_id"], name: "index_articles_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.string "slug"
    t.integer "position"
    t.string "css_class"
    t.string "names_depth_cache"
    t.boolean "active", default: true
    t.index ["ancestry"], name: "index_categories_on_ancestry"
    t.index ["position"], name: "index_categories_on_position"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "category_related_link_translations", force: :cascade do |t|
    t.bigint "category_related_link_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.string "link"
    t.index ["category_related_link_id"], name: "index_149a481cc130d03553cfb6fd9e6bc4d35b1638ae"
    t.index ["locale"], name: "index_category_related_link_translations_on_locale"
  end

  create_table "category_related_links", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_category_related_links_on_category_id"
  end

  create_table "category_translations", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.text "seo_title"
    t.text "description"
    t.index ["category_id"], name: "index_category_translations_on_category_id"
    t.index ["locale"], name: "index_category_translations_on_locale"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.boolean "agreement", default: false
    t.integer "state", default: 0
  end

  create_table "curator_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "rejected_at"
    t.datetime "accepted_at"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_curator_requests_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.string "locale"
    t.index ["locale"], name: "index_friendly_id_slugs_on_locale"
    t.index ["slug", "sluggable_type", "locale"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_locale"
    t.index ["slug", "sluggable_type", "scope", "locale"], name: "index_friendly_id_slugs_uniqueness", unique: true
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "hotel_details", force: :cascade do |t|
    t.string "address"
    t.string "url"
    t.string "description"
    t.integer "service", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "long"
    t.string "lat"
    t.string "currency"
    t.string "min_rate"
    t.bigint "hotel_id"
    t.string "image"
    t.index ["hotel_id"], name: "index_hotel_details_on_hotel_id"
  end

  create_table "hotel_features", force: :cascade do |t|
    t.bigint "hotel_landingpage_id"
    t.integer "feature"
    t.index ["feature"], name: "index_hotel_features_on_feature"
    t.index ["hotel_landingpage_id"], name: "index_hotel_features_on_hotel_landingpage_id"
  end

  create_table "hotel_images", force: :cascade do |t|
    t.bigint "hotel_landingpage_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.index ["hotel_landingpage_id"], name: "index_hotel_images_on_hotel_landingpage_id"
  end

  create_table "hotel_landingpage_articles", force: :cascade do |t|
    t.bigint "hotel_landingpage_id"
    t.bigint "article_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_hotel_landingpage_articles_on_article_id"
    t.index ["hotel_landingpage_id"], name: "index_hotel_landingpage_articles_on_hotel_landingpage_id"
  end

  create_table "hotel_landingpage_translations", force: :cascade do |t|
    t.bigint "hotel_landingpage_id", null: false
    t.string "locale", null: false
    t.string "name"
    t.text "description"
    t.string "price"
    t.string "summary"
    t.string "url"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "official_text"
    t.boolean "recommend_text"
    t.boolean "published"
    t.text "img_src"
    t.string "maps"
    t.index ["hotel_landingpage_id", "locale"], name: "index_hotel_lp_translations_on_lp_id_and_locale", unique: true
    t.index ["hotel_landingpage_id"], name: "index_hotel_landingpage_translations_on_hotel_landingpage_id"
    t.index ["locale"], name: "index_hotel_landingpage_translations_on_locale"
  end

  create_table "hotel_landingpages", force: :cascade do |t|
    t.bigint "area_id"
    t.integer "position", default: 1, null: false
    t.integer "category", default: 1
    t.index ["area_id"], name: "index_hotel_landingpages_on_area_id"
    t.index ["position"], name: "index_hotel_landingpages_on_position"
  end

  create_table "hotels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_hotels_on_name", unique: true
  end

  create_table "images", force: :cascade do |t|
    t.string "img_file_name"
    t.string "img_content_type"
    t.bigint "img_file_size"
    t.datetime "img_updated_at"
  end

  create_table "impressions", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "missing_article_pictures", force: :cascade do |t|
    t.bigint "article_id"
    t.string "locale"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_missing_article_pictures_on_article_id"
  end

  create_table "partner_translations", force: :cascade do |t|
    t.bigint "partner_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "banner_file_name"
    t.text "banner_file_size"
    t.text "banner_content_type"
    t.text "banner_updated_at"
    t.text "title"
    t.text "link"
    t.index ["locale"], name: "index_partner_translations_on_locale"
    t.index ["partner_id"], name: "index_partner_translations_on_partner_id"
  end

  create_table "partners", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position", default: 0, null: false
  end

  create_table "pickup_articles", force: :cascade do |t|
    t.bigint "pickup_id"
    t.bigint "article_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_pickup_articles_on_article_id"
    t.index ["pickup_id"], name: "index_pickup_articles_on_pickup_id"
  end

  create_table "pickup_hotel_lps", force: :cascade do |t|
    t.bigint "hotel_landingpages_id"
    t.integer "position", default: 0
    t.string "lang"
    t.index ["hotel_landingpages_id"], name: "index_pickup_hotel_lps_on_hotel_landingpages_id"
    t.index ["lang"], name: "index_pickup_hotel_lps_on_lang"
  end

  create_table "pickups", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "published_at"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "promo_articles", force: :cascade do |t|
    t.bigint "articles_id"
    t.integer "position", default: 0
    t.string "lang"
    t.index ["articles_id"], name: "index_promo_articles_on_articles_id"
    t.index ["lang"], name: "index_promo_articles_on_lang"
    t.index ["position", "lang"], name: "index_promo_articles_on_position_and_lang"
  end

  create_table "related_articles", force: :cascade do |t|
    t.bigint "article_id"
    t.bigint "related_article_id"
    t.index ["article_id"], name: "index_related_articles_on_article_id"
    t.index ["related_article_id"], name: "index_related_articles_on_related_article_id"
  end

  create_table "rss_feeds", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "article_id"
    t.string "locale"
    t.integer "action"
    t.index ["article_id"], name: "index_rss_feeds_on_article_id"
  end

  create_table "savor_coupon_translations", force: :cascade do |t|
    t.bigint "savor_coupon_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "target"
    t.text "coupon_title"
    t.text "coupon_description"
    t.date "coupon_available_from"
    t.date "coupon_available_to"
    t.date "coupon_publish_from"
    t.date "coupon_publish_to"
    t.index ["locale"], name: "index_savor_coupon_translations_on_locale"
    t.index ["savor_coupon_id"], name: "index_savor_coupon_translations_on_savor_coupon_id"
  end

  create_table "savor_coupons", force: :cascade do |t|
    t.string "coupon_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "restaurant_code"
  end

  create_table "savor_image_data", force: :cascade do |t|
    t.string "lang"
    t.string "photo"
    t.string "photo_genre"
    t.string "photo_caption"
    t.string "information_flag"
    t.string "search_result_flag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "restaurant_code"
  end

  create_table "savor_landmark_translations", force: :cascade do |t|
    t.bigint "savor_landmark_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "spot_name"
    t.text "outline_title"
    t.text "outline"
    t.text "access"
    t.text "address"
    t.string "spot_photo"
    t.index ["locale"], name: "index_savor_landmark_translations_on_locale"
    t.index ["savor_landmark_id"], name: "index_savor_landmark_translations_on_savor_landmark_id"
    t.index ["spot_name"], name: "index_savor_landmark_translations_on_spot_name"
  end

  create_table "savor_landmarks", force: :cascade do |t|
    t.string "pref_code"
    t.string "township_code"
    t.string "sub_township_code"
    t.string "coordinate"
    t.decimal "latitude", precision: 10, scale: 8
    t.decimal "longitude", precision: 11, scale: 8
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "savor_location_translations", force: :cascade do |t|
    t.bigint "savor_location_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "pref"
    t.text "township"
    t.text "sub_township"
    t.index ["locale"], name: "index_savor_location_translations_on_locale"
    t.index ["pref"], name: "index_savor_location_translations_on_pref"
    t.index ["savor_location_id"], name: "index_savor_location_translations_on_savor_location_id"
    t.index ["sub_township"], name: "index_savor_location_translations_on_sub_township"
    t.index ["township"], name: "index_savor_location_translations_on_township"
  end

  create_table "savor_locations", force: :cascade do |t|
    t.string "pref_code"
    t.string "township_code"
    t.string "sub_township_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "savor_menu_translations", force: :cascade do |t|
    t.bigint "savor_menu_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "target"
    t.text "menu_name"
    t.text "menu_caption"
    t.text "menu_price"
    t.text "menu_photo"
    t.index ["locale"], name: "index_savor_menu_translations_on_locale"
    t.index ["savor_menu_id"], name: "index_savor_menu_translations_on_savor_menu_id"
  end

  create_table "savor_menus", force: :cascade do |t|
    t.string "menu_code"
    t.integer "menu_type"
    t.string "carry_page"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "restaurant_code"
  end

  create_table "savor_restaurant_cuisine_type_translations", force: :cascade do |t|
    t.bigint "savor_restaurant_cuisine_type_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "large_category"
    t.text "small_category"
    t.index ["large_category"], name: "large_cat_index"
    t.index ["locale"], name: "index_savor_restaurant_cuisine_type_translations_on_locale"
    t.index ["savor_restaurant_cuisine_type_id"], name: "index_9e58c52da4dd2343923d8485f85de0d6b94144e8"
  end

  create_table "savor_restaurant_cuisine_types", force: :cascade do |t|
    t.string "category_type"
    t.string "large_category_code_name"
    t.string "large_category_jp_name"
    t.string "small_category_code_name"
    t.string "small_category_code"
    t.string "small_category_jp_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "large_category_code"
  end

  create_table "savor_restaurant_translations", force: :cascade do |t|
    t.bigint "savor_restaurant_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "target"
    t.text "information_photo"
    t.text "search_result_photo"
    t.text "name"
    t.text "station_1"
    t.text "station_2"
    t.text "directions"
    t.text "catch_copy_title"
    t.text "catch_copy"
    t.text "open"
    t.text "holiday"
    t.text "address"
    t.text "menu"
    t.integer "languages_available"
    t.integer "ad", default: 0
    t.text "reserve"
    t.index ["locale"], name: "index_savor_restaurant_translations_on_locale"
    t.index ["name"], name: "index_savor_restaurant_translations_on_name"
    t.index ["savor_restaurant_id"], name: "index_savor_restaurant_translations_on_savor_restaurant_id"
  end

  create_table "savor_restaurants", force: :cascade do |t|
    t.string "restaurant_code"
    t.string "jp_name"
    t.string "restaurant_type_class_cd"
    t.string "restaurant_type_cd"
    t.string "tel"
    t.integer "average_price_lunch"
    t.integer "average_price_grand"
    t.string "coordinate"
    t.decimal "lat"
    t.decimal "lng"
    t.integer "internet_available"
    t.integer "free_wifi_available"
    t.integer "mobile_connectable"
    t.integer "separation_of_smoking"
    t.integer "no_smoking"
    t.integer "smoking_available"
    t.integer "course_menu"
    t.integer "large_cocktail_selection"
    t.integer "large_shochu_selection"
    t.integer "large_sake_selection"
    t.integer "large_wine_selection"
    t.integer "all_you_can_eat"
    t.integer "all_you_can_drink"
    t.integer "lunch_menu"
    t.integer "take_out"
    t.integer "coupon"
    t.integer "small_groups"
    t.integer "delivery"
    t.integer "kids_menu"
    t.integer "special_diet"
    t.integer "food_allergy"
    t.integer "vegetarian_menu"
    t.integer "halal_menu"
    t.integer "breakfast"
    t.integer "imported_beer"
    t.integer "reservation"
    t.integer "room_reservation"
    t.integer "storewide_reservation"
    t.integer "late_night_service"
    t.integer "child_friendly"
    t.integer "pet_friendly"
    t.integer "private_room"
    t.integer "tatami_room"
    t.integer "kotatsu"
    t.integer "parking"
    t.integer "barrier_free"
    t.integer "sommelier"
    t.integer "terrace"
    t.integer "live_show"
    t.integer "entertainment_facilities"
    t.integer "karaoke"
    t.integer "band_playable"
    t.integer "tv_projector"
    t.integer "seats_10"
    t.integer "seats_20"
    t.integer "seats_30"
    t.integer "seats_over_30"
    t.integer "membership"
    t.integer "jacuzzi"
    t.integer "vip_room"
    t.integer "donated"
    t.integer "donation_box"
    t.integer "power_saving"
    t.integer "western_cutlery"
    t.integer "counter_seats"
    t.integer "card_accepted"
    t.integer "card_accept_amex"
    t.integer "card_accept_diners"
    t.integer "card_accept_master"
    t.integer "card_accept_visa"
    t.integer "card_accept_unionpay"
    t.integer "electronic_money"
    t.integer "facebook_pages"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "pref_code"
    t.string "township_code"
    t.string "sub_township_code"
    t.string "cuisine_code_1"
    t.string "cuisine_code_2"
    t.string "cuisine_code_3"
    t.index ["cuisine_code_1", "cuisine_code_2", "cuisine_code_3"], name: "cuisine_combined_index"
    t.index ["pref_code"], name: "index_savor_restaurants_on_pref_code"
    t.index ["sub_township_code"], name: "index_savor_restaurants_on_sub_township_code"
    t.index ["township_code"], name: "index_savor_restaurants_on_township_code"
  end

  create_table "sidebar_ad_translations", force: :cascade do |t|
    t.bigint "sidebar_ad_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "banner_file_name"
    t.text "banner_file_size"
    t.text "banner_content_type"
    t.text "banner_updated_at"
    t.datetime "publish_start"
    t.datetime "publish_end"
    t.text "url"
    t.index ["locale"], name: "index_sidebar_ad_translations_on_locale"
    t.index ["publish_start", "publish_end"], name: "index_sidebar_ad_translations_on_publish_start_and_publish_end"
    t.index ["sidebar_ad_id"], name: "index_sidebar_ad_translations_on_sidebar_ad_id"
  end

  create_table "sidebar_ads", force: :cascade do |t|
    t.string "label"
    t.string "analytics_category"
    t.string "analytics_label"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position", default: 0
  end

  create_table "social_identities", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "nickname"
    t.string "email"
    t.string "url"
    t.string "image_url"
    t.string "description"
    t.text "others"
    t.text "credentials"
    t.text "raw_info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_social_identities_on_user_id"
  end

  create_table "tag_group_to_articles", force: :cascade do |t|
    t.bigint "tag_group_id"
    t.bigint "article_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_tag_group_to_articles_on_article_id"
    t.index ["tag_group_id"], name: "index_tag_group_to_articles_on_tag_group_id"
  end

  create_table "tag_group_translations", force: :cascade do |t|
    t.bigint "tag_group_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["locale"], name: "index_tag_group_translations_on_locale"
    t.index ["tag_group_id"], name: "index_tag_group_translations_on_tag_group_id"
  end

  create_table "tag_groups", force: :cascade do |t|
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.integer "position"
    t.index ["category_id"], name: "index_tag_groups_on_category_id"
    t.index ["slug"], name: "index_tag_groups_on_slug", unique: true
  end

  create_table "tag_to_cats", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_tag_to_cats_on_category_id"
  end

  create_table "tag_translations", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.text "description"
    t.index ["locale"], name: "index_tag_translations_on_locale"
    t.index ["name"], name: "index_tag_translations_on_name"
    t.index ["tag_id"], name: "index_tag_translations_on_tag_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "article_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "lang"
    t.index ["article_id", "lang"], name: "index_taggings_on_article_id_and_lang"
    t.index ["article_id"], name: "index_taggings_on_article_id"
    t.index ["lang"], name: "index_taggings_on_lang"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.string "slug"
    t.integer "article_count"
    t.index ["ancestry"], name: "index_tags_on_ancestry"
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  create_table "top_page_section_translations", force: :cascade do |t|
    t.bigint "top_page_section_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.string "more_btn_link"
    t.string "more_btn_text"
    t.boolean "active"
    t.integer "selected_template"
    t.index ["locale"], name: "index_top_page_section_translations_on_locale"
    t.index ["top_page_section_id"], name: "index_top_page_section_translations_on_top_page_section_id"
  end

  create_table "top_page_sections", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "top_page_sections_element_translations", force: :cascade do |t|
    t.bigint "top_page_sections_element_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.string "link"
    t.text "image_file_name"
    t.text "image_file_size"
    t.text "image_content_type"
    t.text "image_updated_at"
    t.integer "position"
    t.index ["locale"], name: "index_top_page_sections_element_translations_on_locale"
    t.index ["top_page_sections_element_id"], name: "index_1cfb1e7aacdf3696d0663bd4bce24e35028e5b8d"
  end

  create_table "top_page_sections_elements", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "top_page_section_id"
    t.index ["top_page_section_id"], name: "index_top_page_sections_elements_on_top_page_section_id"
  end

  create_table "tour_translations", force: :cascade do |t|
    t.bigint "tour_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "banner_file_name"
    t.text "banner_file_size"
    t.text "banner_content_type"
    t.text "banner_updated_at"
    t.text "title"
    t.text "details"
    t.string "price"
    t.text "duration"
    t.jsonb "buttons", default: []
    t.index ["locale"], name: "index_tour_translations_on_locale"
    t.index ["tour_id"], name: "index_tour_translations_on_tour_id"
  end

  create_table "tours", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "area_id"
    t.integer "position", default: 0, null: false
    t.index ["area_id"], name: "index_tours_on_area_id"
  end

  create_table "user_translations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "facebook"
    t.string "instagram"
    t.string "twitter"
    t.string "google"
    t.string "pintrest"
    t.string "description"
    t.index ["locale"], name: "index_user_translations_on_locale"
    t.index ["user_id"], name: "index_user_translations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", default: 0
    t.string "username"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer "has_page", default: 0
    t.boolean "pass_changed", default: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "video_translations", force: :cascade do |t|
    t.bigint "video_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "title"
    t.text "link"
    t.text "user"
    t.index ["locale"], name: "index_video_translations_on_locale"
    t.index ["video_id"], name: "index_video_translations_on_video_id"
  end

  create_table "videos", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position", default: 0, null: false
  end

  create_table "weathers", force: :cascade do |t|
    t.integer "degrees"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "location"
    t.jsonb "forecast"
    t.index ["location"], name: "index_weathers_on_location"
  end

  add_foreign_key "article_translators", "articles"
  add_foreign_key "article_translators", "users"
  add_foreign_key "article_users", "articles"
  add_foreign_key "article_users", "users"
  add_foreign_key "articles", "areas"
  add_foreign_key "articles", "categories"
  add_foreign_key "category_related_links", "categories"
  add_foreign_key "curator_requests", "users"
  add_foreign_key "hotel_details", "hotels"
  add_foreign_key "hotel_features", "hotel_landingpages"
  add_foreign_key "hotel_landingpage_articles", "articles"
  add_foreign_key "hotel_landingpage_articles", "hotel_landingpages"
  add_foreign_key "hotel_landingpage_translations", "hotel_landingpages"
  add_foreign_key "pickup_articles", "articles"
  add_foreign_key "pickup_articles", "pickups"
  add_foreign_key "related_articles", "articles"
  add_foreign_key "related_articles", "articles", column: "related_article_id"
  add_foreign_key "rss_feeds", "articles"
  add_foreign_key "social_identities", "users"
  add_foreign_key "tag_group_to_articles", "articles"
  add_foreign_key "tag_group_to_articles", "tag_groups"
  add_foreign_key "tag_groups", "categories"
  add_foreign_key "taggings", "articles"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tours", "areas"
end
