Rails.application.routes.draw do
  # ALB health check
  get '/health', to: proc { [200, {}, ['OK']] }

  get 'errors/not_found'
  get 'errors/internal_server_error'
  get '/sitemap.xml.gz', to: redirect("https://s3.ap-northeast-1.amazonaws.com/#{ENV["TNG_S3_BUCKET"]}/sitemap.xml.gz")
  get '/sitemap_area.xml.gz', to: redirect("https://s3.ap-northeast-1.amazonaws.com/#{ENV["TNG_S3_BUCKET"]}/sitemap_area.xml.gz")
  get '/sitemap_category.xml.gz', to: redirect("https://s3.ap-northeast-1.amazonaws.com/#{ENV["TNG_S3_BUCKET"]}/sitemap_category.xml.gz")
  get '/sitemap_category_listing.xml.gz', to: redirect("https://s3.ap-northeast-1.amazonaws.com/#{ENV["TNG_S3_BUCKET"]}/sitemap_category_listing.xml.gz")
  # Use custom registrations_controller as we put extra field to sign up
  # devise_for :users, controllers: { registrations: 'registrations',
  #                                   confirmations: 'confirmations',
  #                                   omniauth_callbacks: 'omniauth_callbacks'
  #                                 }

  # アセットプリコンパイル時にアプリ全体を初期化しないための設定（Dockerfileで[SKIP_MOUNT_ROUTES==1]を指定した場合、ビルド時にdeviseのルーティングをスキップする）
  unless ENV['SKIP_MOUNT_ROUTES'] == '1'
    devise_for :users, controllers: {
      registrations: 'registrations',
      confirmations: 'confirmations',
      omniauth_callbacks: 'omniauth_callbacks'
    }
  end

  get "/category/accomodation" => redirect("/category/accommodation")

  # redirect
  get "/tour" => redirect("/")
  get "/ja/tour" => redirect("/ja/")
  get "/zh-hant/tour" => redirect("/zh-hant/")
  get "/zh-hans/tour" => redirect("/zh-hans/")
  get "/th/tour" => redirect("/th/")
  get "/vi/tour" => redirect("/vi/")
  get "/ko/tour" => redirect("/ko/")
  get "/id/tour" => redirect("/id/")

  #redirect to Becos
  get "/kyo-sensu-fans" => redirect("https://en.thebecos.com/blogs/column/kyo-sensu-fans/")
  get "/satsuma-kiriko" => redirect("https://en.thebecos.com/blogs/column/satsuma-kiriko/")
  get "/a-guide-to-the-traditional-japanese-crafts-edo-cut-glass" => redirect("https://en.thebecos.com/blogs/column/a-guide-to-the-traditional-japanese-crafts-edo-cut-glass/")
  get "/mino-ware-glasses" => redirect("https://en.thebecos.com/blogs/column/mino-ware-glasses/")
  get "/edo-sensu-fans" => redirect("https://en.thebecos.com/blogs/column/edo-sensu-fans/")
  get "/japanese-craftwork" => redirect("https://en.thebecos.com/blogs/column/japanese-craftwork/")
  get "/kanazawa-gold-leaf-guide" => redirect("https://en.thebecos.com/blogs/column/kanazawa-gold-leaf-guide/")
  get "/introducing-echizen-uchihamono" => redirect("https://en.thebecos.com/blogs/column/introducing-echizen-uchihamono/")
  get "/7-not-so-dry-facts-about-japanese-towels" => redirect("https://en.thebecos.com/blogs/column/7-not-so-dry-facts-about-japanese-towels/")
  get "/japanese-lacquerware-guide" => redirect("https://en.thebecos.com/blogs/column/japanese-lacquerware-guide/")
  get "/tamatex-imabari-towel" => redirect("https://en.thebecos.com/blogs/column/tamatex-imabari-towel/")
  get "/japanese-dolls-guide" => redirect("https://en.thebecos.com/blogs/column/japanese-dolls-guide/")
  get "/yamawaki-cutlery-sakai-knives" => redirect("https://en.thebecos.com/blogs/column/yamawaki-cutlery-sakai-knives/")
  get "/wajima-nuri" => redirect("https://en.thebecos.com/blogs/column/wajima-nuri/")
  get "/traditional-japanese-crafts-defined" => redirect("https://en.thebecos.com/blogs/column/traditional-japanese-crafts-defined/")
  get "/traditional-japanese-crafts-by-industry" => redirect("https://en.thebecos.com/blogs/column/traditional-japanese-crafts-by-industry/")
  get "/traditional-japanese-crafts-complete-guide" => redirect("https://en.thebecos.com/blogs/column/traditional-japanese-crafts-complete-guide/")
  get "/japanese-ceramics-guide" => redirect("https://en.thebecos.com/blogs/column/japanese-ceramics-guide/")
  get "/8-things-you-didnt-know-about-japanese-kitchen-knives" => redirect("https://en.thebecos.com/blogs/column/8-things-you-didnt-know-about-japanese-kitchen-knives/")
  get "/ko/tamatex-imabari-towel/" => redirect("https://en.thebecos.com/ko/blogs/column/tamatex-imabari-towel/")
  get "/ko/japanese-ceramics-guide/" => redirect("https://en.thebecos.com/ko/blogs/column/japanese-ceramics-guide/")
  get "/ko/traditional-japanese-crafts-complete-guide/" => redirect("https://en.thebecos.com/ko/blogs/column/traditional-japanese-crafts-complete-guide/")
  get "/ko/traditional-japanese-crafts-summary/" => redirect("https://en.thebecos.com/ko/blogs/column/traditional-japanese-crafts-by-industry/")
  get "/th/introducing-echizen-uchihamono/" => redirect("https://en.thebecos.com/th/blogs/column/introducing-echizen-uchihamono/")
  get "/th/kanazawa-gold-leaf-guide/" => redirect("https://en.thebecos.com/th/blogs/column/kanazawa-gold-leaf-guide/")

  # Area Feature
  get "/ja/area/hokkaido/feature/" => redirect("/area/hokkaido/feature/")
  get "/ja/area/tohoku/feature/" => redirect("/area/tohoku/feature/")
  get "/ja/area/kanto/feature/" => redirect("/area/kanto/feature/")
  get "/ja/area/shikoku/feature/" => redirect("/area/shikoku/feature/")
  get "/ja/area/kyushu/feature/" => redirect("/area/kyushu/feature/")
  get "/ja/area/okinawa/feature/" => redirect("/area/okinawa/feature/")

  get "/ja/area/setouchi/feature/" => redirect("/area/setouchi/feature/")
  get "/zh-hant/area/setouchi/feature/" => redirect("/area/setouchi/feature/")
  get "/zh-hans/area/setouchi/feature/" => redirect("/area/setouchi/feature/")
  get "/th/area/setouchi/feature/" => redirect("/area/setouchi/feature/")
  get "/vi/area/setouchi/feature/" => redirect("/area/setouchi/feature/")
  get "/ko/area/setouchi/feature/" => redirect("/area/setouchi/feature/")
  get "/id/area/setouchi/feature/" => redirect("/area/setouchi/feature/")

  get "/ja/area/kansai/feature/" => redirect("/area/kansai/feature/")
  get "/zh-hans/area/kansai/feature/" => redirect("/area/kansai/feature/")
  get "/ko/area/kansai/feature/" => redirect("/area/kansai/feature/")
  get "/id/area/kansai/feature/" => redirect("/area/kansai/feature/")

  get "/ja/area/chubu/feature/" => redirect("/area/chubu/feature/")
  get "/zh-hans/area/chubu/feature/" => redirect("/area/chubu/feature/")
  get "/ko/area/chubu/feature/" => redirect("/area/chubu/feature/")
  get "/id/area/chubu/feature/" => redirect("/area/chubu/feature/")

  get "/ja/area/chubu/feature/" => redirect("/area/chubu/feature/")
  get "/zh-hans/area/chugoku/feature/" => redirect("/area/chugoku/feature/")
  get "/ko/area/chugoku/feature/" => redirect("/area/chugoku/feature/")
  get "/id/area/chugoku/feature/" => redirect("/area/chugoku/feature/")

  # Category Feature Redirect
  get "/zh-hans/category/feature/" => redirect("/category/feature/")
  get "/ko/category/feature/" => redirect("/category/feature/")
  get "/id/category/feature/" => redirect("/category/feature/")

  # POJ Redirect
  get "/zh-hans/category/feature/people-of-japan/" => redirect("/category/feature/people-of-japan/")
  get "/ko/category/feature/people-of-japan/" => redirect("/category/feature/people-of-japan/")
  get "/id/category/feature/people-of-japan/" => redirect("/category/feature/people-of-japan/")

  # AOJ Redirect
  # AOJ a
  get "/zh-hans/category/feature/aoj-one-day-free-in-tokyo/" => redirect("/category/feature/aoj-one-day-free-in-tokyo/")
  get "/ko/category/feature/aoj-one-day-free-in-tokyo/" => redirect("/category/feature/aoj-one-day-free-in-tokyo/")
  get "/id/category/feature/aoj-one-day-free-in-tokyo/" => redirect("/category/feature/aoj-one-day-free-in-tokyo/")
  # AOJ b
  get "/zh-hans/category/feature/aoj-our-top-tokyo-spots-to-introduce-to-family-and-friends/" => redirect("/category/feature/aoj-our-top-tokyo-spots-to-introduce-to-family-and-friends/")
  get "/th/category/feature/aoj-our-top-tokyo-spots-to-introduce-to-family-and-friends/" => redirect("/category/feature/aoj-our-top-tokyo-spots-to-introduce-to-family-and-friends/")
  get "/vi/category/feature/aoj-our-top-tokyo-spots-to-introduce-to-family-and-friends/" => redirect("/category/feature/aoj-our-top-tokyo-spots-to-introduce-to-family-and-friends/")
  get "/ko/category/feature/aoj-our-top-tokyo-spots-to-introduce-to-family-and-friends/" => redirect("/category/feature/aoj-our-top-tokyo-spots-to-introduce-to-family-and-friends/")
  get "/id/category/feature/aoj-our-top-tokyo-spots-to-introduce-to-family-and-friends/" => redirect("/category/feature/aoj-our-top-tokyo-spots-to-introduce-to-family-and-friends/")
  #AOJ c
  get "/zh-hans/category/feature/aoj-traveling-the-jr-chuo-line/" => redirect("/category/feature/aoj-traveling-the-jr-chuo-line/")
  get "/th/category/feature/aoj-traveling-the-jr-chuo-line/" => redirect("/category/feature/aoj-traveling-the-jr-chuo-line/")
  get "/vi/category/feature/aoj-traveling-the-jr-chuo-line/" => redirect("/category/feature/aoj-traveling-the-jr-chuo-line/")
  get "/ko/category/feature/aoj-traveling-the-jr-chuo-line/" => redirect("/category/feature/aoj-traveling-the-jr-chuo-line/")
  get "/id/category/feature/aoj-traveling-the-jr-chuo-line/" => redirect("/category/feature/aoj-traveling-the-jr-chuo-line/")
  #AOJ d
  get "/zh-hans/category/feature/aoj-best-spots-keio-inokashira-line/" => redirect("/category/feature/aoj-best-spots-keio-inokashira-line/")
  get "/th/category/feature/aoj-best-spots-keio-inokashira-line/" => redirect("/category/feature/aoj-best-spots-keio-inokashira-line/")
  get "/vi/category/feature/aoj-best-spots-keio-inokashira-line/" => redirect("/category/feature/aoj-best-spots-keio-inokashira-line/")
  get "/ko/category/feature/aoj-best-spots-keio-inokashira-line/" => redirect("/category/feature/aoj-best-spots-keio-inokashira-line/")
  get "/id/category/feature/aoj-best-spots-keio-inokashira-line/" => redirect("/category/feature/aoj-best-spots-keio-inokashira-line/")
  #AOJ e
  get "/zh-hans/category/feature/aoj-best-day-trips-from-tokyo/" => redirect("/category/feature/aoj-best-day-trips-from-tokyo/")
  get "/th/category/feature/aoj-best-day-trips-from-tokyo/" => redirect("/category/feature/aoj-best-day-trips-from-tokyo/")
  get "/vi/category/feature/aoj-best-day-trips-from-tokyo/" => redirect("/category/feature/aoj-best-day-trips-from-tokyo/")
  get "/ko/category/feature/aoj-best-day-trips-from-tokyo/" => redirect("/category/feature/aoj-best-day-trips-from-tokyo/")
  get "/id/category/feature/aoj-best-day-trips-from-tokyo/" => redirect("/category/feature/aoj-best-day-trips-from-tokyo/")

  # COJ Redirect
  # COJ b
  get "/zh-hans/category/feature/coj-tips-tricks-for-enjoying-japanese-food-drinks/" => redirect("/category/feature/coj-tips-tricks-for-enjoying-japanese-food-drinks/")
  get "/ko/category/feature/coj-tips-tricks-for-enjoying-japanese-food-drinks/" => redirect("/category/feature/coj-tips-tricks-for-enjoying-japanese-food-drinks/")
  get "/id/category/feature/coj-tips-tricks-for-enjoying-japanese-food-drinks/" => redirect("/category/feature/coj-tips-tricks-for-enjoying-japanese-food-drinks/")
  # COJ C
  get "/zh-hans/category/feature/coj-healthy-traditional-japanese-foods/" => redirect("/category/feature/coj-healthy-traditional-japanese-foods/")
  get "/th/category/feature/coj-healthy-traditional-japanese-foods/" => redirect("/category/feature/coj-healthy-traditional-japanese-foods/")
  get "/vi/category/feature/coj-healthy-traditional-japanese-foods/" => redirect("/category/feature/coj-healthy-traditional-japanese-foods/")
  get "/ko/category/feature/coj-healthy-traditional-japanese-foods/" => redirect("/category/feature/coj-healthy-traditional-japanese-foods/")
  get "/id/category/feature/coj-healthy-traditional-japanese-foods/" => redirect("/category/feature/coj-healthy-traditional-japanese-foods/")
  # COJ d
  get "/zh-hans/category/feature/coj-know-traditional-japanese-crafts-culture/" => redirect("/category/feature/coj-know-traditional-japanese-crafts-culture/")
  get "/th/category/feature/coj-know-traditional-japanese-crafts-culture/" => redirect("/category/feature/coj-know-traditional-japanese-crafts-culture/")
  get "/vi/category/feature/coj-know-traditional-japanese-crafts-culture/" => redirect("/category/feature/coj-know-traditional-japanese-crafts-culture/")
  get "/ko/category/feature/coj-know-traditional-japanese-crafts-culture/" => redirect("/category/feature/coj-know-traditional-japanese-crafts-culture/")
  get "/id/category/feature/coj-know-traditional-japanese-crafts-culture/" => redirect("/category/feature/coj-know-traditional-japanese-crafts-culture/")
  # COJ e
  get "/zh-hans/category/feature/coj-easy-ways-to-experience-japanese-culture/" => redirect("/category/feature/coj-easy-ways-to-experience-japanese-culture/")
  get "/th/category/feature/coj-easy-ways-to-experience-japanese-culture/" => redirect("/category/feature/coj-easy-ways-to-experience-japanese-culture/")
  get "/vi/category/feature/coj-easy-ways-to-experience-japanese-culture/" => redirect("/category/feature/coj-easy-ways-to-experience-japanese-culture/")
  get "/ko/category/feature/coj-easy-ways-to-experience-japanese-culture/" => redirect("/category/feature/coj-easy-ways-to-experience-japanese-culture/")
  get "/id/category/feature/coj-easy-ways-to-experience-japanese-culture/" => redirect("/category/feature/coj-easy-ways-to-experience-japanese-culture/")
  #COJ f
  get "/zh-hans/category/feature/coj-japanese-subcultures/" => redirect("/category/feature/coj-japanese-subcultures/")
  get "/th/category/feature/coj-japanese-subcultures/" => redirect("/category/feature/coj-japanese-subcultures/")
  get "/vi/category/feature/coj-japanese-subcultures/" => redirect("/category/feature/coj-japanese-subcultures/")
  get "/ko/category/feature/coj-japanese-subcultures/" => redirect("/category/feature/coj-japanese-subcultures/")
  get "/id/category/feature/coj-japanese-subcultures/" => redirect("/category/feature/coj-japanese-subcultures/")


  # article Redirect SCRUM-464 20231018
  get "/zh-hant/15-beautiful-japanese-villages-you-must-visit/" => redirect("/zh-hant/20-beautiful-village-in-japan/")
  get "/zh-hant/how-to-spend-a-whole-day-in-tokyo-station/" => redirect("/zh-hant/what-to-do-tokyo-station/")
  get "/zh-hant/what-is-it-like-having-tattoos-in-japan/" => redirect("/zh-hant/17-facts-you-probably-didnt-know-about-tattoos-in-japan/")
  get "/zh-hant/10-souvenirs-you-must-buy-in-osaka/" => redirect("/zh-hant/20-must-buy-souvenirs-from-osaka/")
  get "/zh-hant/15-popular-okonomiyaki-shops-to-try-in-osaka/" => redirect("/zh-hant/osaka-namba-recommended-okonomiyaki-restaurants/")
  get "/zh-hant/7-great-okonomiyaki-restaurants-in-the-food-capital-osaka/" => redirect("/zh-hant/osaka-namba-recommended-okonomiyaki-restaurants/")
  get "/zh-hant/the-right-way-to-eat-the-famous-osaka-kushikatsu/" => redirect("/zh-hant/osaka-gourmet-kushikatsu/")
  get "/zh-hant/tokyobay-drama-tennozu-isle/" => redirect("/zh-hant/art-and-design-island-tokyo-tennoz-isle/")
  # 20240523
  get "/zh-hant/8-shinjyuku-conveyor-belt-sushi/" => redirect("/zh-hant/10-conveyor-belt-sushi-places-in-shinjuku-to-go-to/")
  get "/zh-hant/10-must-visit-spots-in-awaji-island/" => redirect("/zh-hant/awajishima-power-spots/")
  get "/zh-hant/12weather-in-tokyo/" => redirect("/zh-hant/a-guide-to-tokyos-climate-throughout-the-year/")
  get "/zh-hant/10-things-to-do-in-and-around-tokyo-station/" => redirect("/zh-hant/what-to-do-tokyo-station/")
  get "/zh-hant/20-must-visit-kurashiki-spots/" => redirect("/zh-hant/20-recommended-travel-attractions-in-okayama-kurashiki/")
  get "/zh-hant/gunma-ikaho-onsen-30-tourist-attractions/" => redirect("/zh-hant/gunma-ikaho-onsen-gourmet-2-days-trip/")
  get "/zh-hant/10-noryo-yuka-restaurants-in-kyoto/" => redirect("/zh-hant/kyouto-noryoyuka-15-restaurants/")
  get "/zh-hant/noryo-yuka-restaurants-in-kyoto-summer/" => redirect("/zh-hant/kyouto-noryoyuka-15-restaurants/")
  get "/zh-hant/6-ways-to-enjoy-tokyo-dome/" => redirect("/zh-hant/about-tokyo-dome-city/")

  # Admin views
  namespace :admin, :path => "admin1500011" do
    scope "(:locale)",  locale: /#{I18n.available_locales.join("|")}/ do
      get 'lang/:locale', to: 'dashboard#change_locale', as: :change_locale
      get '/dashboard', to: "dashboard#index", as: :dashboard
      root to: "dashboard#index"

      resources :areas do
        post :import, on: :collection
        collection do
          get '/search/:query', to: "areas#search", as: :search
          get '/:id/edit(/:lang)', to: "areas#edit"
          post :sort
        end
      end

      resources :tags do
        post :import, on: :collection
        collection do

          get '/search/:query', to: "tags#search", as: :search
          get '/:id/edit(/:lang)', to: "tags#edit"
          get '/merge', to: "tags#merge_view"
          get '/merge_edit', to: "tags#merge_edit_view"
          get '/merge/:id/:into', to: "tags#merge_by_ids", as: :merge_by_ids
          post '/merge', to: "tags#create_and_merge", as: :create_and_merge
        end
      end
      resources :category_related_links
      resources :categories do
        post :import, on: :collection
        collection do
          get '/search/:query', to: "categories#search", as: :search
          get '/:id/edit(/:lang)', to: "categories#edit"
        end
        member do
          post :move
        end
      end
      resources :contacts do
        collection do
          post "/answer", to: "contacts#answer", as: :answer
        end
      end
      resources :flush_cache do
        collection do
          get '/', to: "flush_caches#flush", as: :flush_cache
        end
      end

      resources :pickups do
        collection do
          get '/pick_article', to: "pickups#pick_article", as: :pick_article
        end
        member do
          patch '/publish', to: "pickups#publish", as: :publish
          patch '/unpublish', to: "pickups#unpublish", as: :unpublish
        end
      end

      resources :tours do
        member do
          post :move
        end
      end

      resources :partners do
        member do
          post :move
        end
      end

      resources :videos do
        member do
          post :move
        end
      end

      resources :sidebar_ads do
        member do
          post :move
        end
      end
      resources :tag_groups do
        member do
          post :move
        end
      end
      resources :articles do
        post :import, on: :collection
        collection do
          get 'landingpages' , to: "articles#landingpage_show", as: :landingpage_show
          get 'otomo' , to: "articles#otomo_show", as: :otomo_show
          get 'coupons' , to: "articles#coupon_show", as: :coupon_show
          get 'duplicate/:id', to: "articles#duplicate", as: :duplicate
          get '/bulk_edit/', to: "articles#bulk_edit", as: :bulk_edit
          patch '/bulk_edit/save', to: "articles#bulk_save", as: :bulk_save
          patch '/quick_save/save', to: "articles#quick_save", as: :quick_save
          get 'quick_edit/:id', to: "articles#quick_edit", as: :quick_edit
          patch '/change_status', to: "articles#change_status", as: :change_state
        end
      end
      resources :hotel_landingpages do
        post :import, on: :collection
        collection do
          delete "/image_destroy", to: "hotel_landingpages#destroy_image"
          delete "/pickup_del/:id", to: "hotel_landingpages#destroy_pickup", as: :delete_pickup
          get '/pick', to: "hotel_landingpages#pick_lang", as: :pickup_lang
          get '/pick_select/:lang', to: "hotel_landingpages#select_pick", as: :select_pickup
        end
        member do
          post :move
        end
      end
      resources :article_groups do
        collection do
          get '/pick_article', to: "article_groups#pick_article", as: :pick_article
          get '/pick_article/s', to: "article_groups#pick_article_search", as: :pick_article_search
          post '/add_articles', to: "article_groups#add_articles", as: :add_articles
          post :sort
          get '/:id/edit(/:lang)', to: "article_groups#edit"
        end
        resources :article_groupings
      end
      resources :article_grouping_favorites

      resources :promo_articles do
        collection do
          delete 'promo_articles/:id', to: "promo_articles#destroy", as: :delete
        end

      end

      resources :curator_requests do
        member do
          patch '/accept', to: "curator_requests#accept", as: :accept
          patch '/reject', to: "curator_requests#reject", as: :reject
        end
      end

      resources :users

      resources :missing_images
      resources :images
      resources :rss_feeds

      resources :top_page_sections
      resources :top_page_sections_elements do
        member do
          post :move
          delete 'delete_lang', to: "top_page_sections_elements#destroy_translation"
        end
      end
    end
  end

  # APIs
  namespace :api do
    # API adapters
    namespace :adapters do
      scope :twitter do
        get '/search', to: "twitter#search", as: :search
      end
      scope :pixta do
        get '/category-list', to: "pixta#category_list", as: :pixta_category_list
        get '/category-search/:cateogry_id', to: "pixta#category_search", as: :pixta_category_search
        get '/search/:query', to: "pixta#search", as: :pixta_search
        get '/image-details/:id', to: "pixta#image_details", as: :pixta_image_details
        get '/download/:id/:size', to: "pixta#download", as: :pixta_download
      end
      scope :related_group do
        get '/list', to: "related_group#get_list"
        get '/articles/:id', to: "related_group#get_articles"
      end
    end
  end

  # Public views
  #redirect en

  resource :curator_request, only: [:new, :create], controller: :curator_request do
    get 'thankyou', to: "curator_request#thankyou"
  end

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root 'index#index'
    delete 'lock/',to: 'article_editor#remove_lock'
    %w( 404 422 500 503 ).each do |code|
      get code, :to => "errors#show", :code => code
    end
    get '/service-worker.js' => "service_worker#service_worker"
    get '/manifest.json' => "service_worker#manifest"
    get '/offline.html' => "service_worker#offline"
    put '/ping_lock/', to: 'article_editor#ping'

    # Traveling Safely in Japan
    get "/traveling-safely-in-japan/" => "pages#corona"
    get "/traveling-safely-in-japan/detail(/:tab)" => "pages#corona_detail", as: "traveling_safely_in_japan_detail"
    get "/traveling-safely-in-japan/place(/:tab)" => "pages#place_list", as: "traveling_safely_in_japan_place"
    get "/traveling-safely-in-japan/category(/:tab)" => "pages#category_detail", as: "traveling_safely_in_japan_category"

    # Your Complete Guide to Planning a Trip to Japan
    get "/planning-a-trip-to-japan/" => "pages#planning", as: "planning_a_trip_to_japan"

    # get "/traveling-safely-in-japan/api/places(/:tab)" => "api#places", as: "traveling_safely_in_japan_api_place"
    get "/api/places(/:tab)" => "api#places", as: "traveling_safely_in_japan_api_place"

    get "/:id/" => "pages#show", :constraints => PagesConstraint
    get "/clips/" => "clips#index"
    get "/special-offer/:id/" => "pages#special_offer", :constraints => OfferConstraint
    get 'tag/:tag/(page/:page)', to: 'tags#list_articles', as: "tag"

    get 'author/:author/', to: 'users#list_articles', as: "author"
    get 'search/:search/(page/:page)', to: 'search#list_articles', as: "search"
    get 'search/', to: 'search#list_articles', as: "search_form"
    get 'area/', to: 'areas#index', as: "area-listing"
    get 'ranking/(:page)', to: 'rankings#index', as: "rankings"
    get 'area/:area/', to: 'areas#list_articles', as: "area"

    # 北海道
    get 'area/hokkaido/feature', to: 'pages#feature_hokkaido', as: "area_hokkaido_feature"
    # 東北
    get 'area/tohoku/feature', to: 'pages#feature_tohoku', as: "area_tohoku_feature"
    # 九州
    get 'area/kyushu/feature', to: 'pages#feature_kyushu', as: "area_kyushu_feature"
    # 沖縄
    get 'area/okinawa/feature', to: 'pages#feature_okinawa', as: "area_okinawa_feature"
    # 四国
    get 'area/shikoku/feature', to: 'pages#feature_shikoku', as: "area_shikoku_feature"
    # Setouchi
    get 'area/setouchi/feature', to: 'pages#feature_setouchi', as: "area_setouchi_feature"
    # Kanto
    get 'area/kanto/feature', to: 'pages#feature_kanto', as: "area_kanto_feature"
    # Kansai
    get 'area/kansai/feature', to: 'pages#feature_kansai', as: "area_kansai_feature"
    # Chubu
    get 'area/chubu/feature', to: 'pages#feature_chubu', as: "area_chubu_feature"
    # Chugoku
    get 'area/chugoku/feature', to: 'pages#feature_chugoku', as: "area_chugoku_feature"

    # Gunma
    get 'area/gunma/feature', to: 'pages#feature_gunma', as: "area_gunma_feature"

    # Gunma FIT Promotion
    get 'gunma_excellence', to: 'pages#gunma_excellence', as: "gunma_excellence"
    get 'gunma_excellence_b', to: 'pages#gunma_excellence_b', as: "gunma_excellence_b"

    # Setouchi Mail Magazine
    get 'setouchi_newsletter', to: 'pages#setouchi_newsletter', as: "setouchi_newsletter"

    # SCRUN-499 Experience Echigo
    get 'experience-echigo', to: 'pages#experience_echigo', as: "experience_echigo"

    # Feature
    # list
    get 'category/feature', to: 'pages#feature_index', as: "category_feature_index"

    # people of japan
    get 'category/feature/people-of-japan', to: 'pages#feature_poj', as: "category_feature_people_of_japan"

    # area of japan
    get 'category/feature/aoj-one-day-free-in-tokyo', to: 'pages#feature_aoj_a', as: "category_feature_aoj_a"
    get 'category/feature/aoj-our-top-tokyo-spots-to-introduce-to-family-and-friends', to: 'pages#feature_aoj_b', as: "category_feature_aoj_b"
    get 'category/feature/aoj-traveling-the-jr-chuo-line', to: 'pages#feature_aoj_c', as: "category_feature_aoj_c"
    get 'category/feature/aoj-best-spots-keio-inokashira-line', to: 'pages#feature_aoj_d', as: "category_feature_aoj_d"
    get 'category/feature/aoj-best-day-trips-from-tokyo', to: 'pages#feature_aoj_e', as: "category_feature_aoj_e"

    # culture of japan
    get 'category/feature/coj-tips-tricks-for-enjoying-japanese-food-drinks', to: 'pages#feature_coj_b', as: "category_feature_coj_b"
    get 'category/feature/coj-healthy-traditional-japanese-foods', to: 'pages#feature_coj_c', as: "category_feature_coj_c"
    get 'category/feature/coj-know-traditional-japanese-crafts-culture', to: 'pages#feature_coj_d', as: "category_feature_coj_d"
    get 'category/feature/coj-easy-ways-to-experience-japanese-culture', to: 'pages#feature_coj_e', as: "category_feature_coj_e"
    get 'category/feature/coj-japanese-subcultures', to: 'pages#feature_coj_f', as: "category_feature_coj_f"

    # tsunagu Japan Jobs
    get 'tsunagu-japan-jobs', to: 'pages#tj_jobs', as: "tsunagu_japan_jobs"

    # tsunagu Japan Travel
    get 'tsunagu-japan-travel-dmc', to: 'pages#tj_dmc', as: "tsunagu_japan_dmc"

    get 'tags/', to: 'tags#index', as: "taglist"
    get 'featured/:pickup', to: 'pickups#index', as: "pickup"
    get 'category/hotels-ryokan/recommended/(:area)', to: 'hotel_landingpages#index', as: "hotelp"
    get 'category/:category/(:area)(/page/:page)', to: 'category#index', as: "categoryListing"
    get 'category/:category/g/:group(/page/:page)', to: 'category#index', as: "categoryListingGroup"
    get 'coupon', to: 'coupons#index', as: "coupons"
    get 'tour/:id', to: 'tour#otomo', as: "otomo"
    get 'coupon/:id', to: 'coupons#show', as: "show_coupons"
    resources :tour
    resources :video
    resources :partners
    resources :category, concerns: :paginatable
    # resources :restaurant_search, :path => "restaurant" do
    #   collection do
    #     get '/search', to:"restaurant_search#search"
    #     get '/autocomplete/landmark', to:"restaurant_search#autocomplete_landmark_location"
    #     get '/autocomplete/cuisine', to:"restaurant_search#autocomplete_cuisine"
    #   end
    # end
    # resources :savor_restaurant, only: [:update]
    # Restaurant search redirect
    get '/restaurant', to: redirect('/')
    get '/restaurant/*path', to: redirect('/')

    resources :image
    resources :pois, only: [:show]
    get 'hotels/:query/' => 'hotels#search', as: "hotel_search"
    get 'hotel/:id/' => 'hotels#show', as: "hotel_show"
    get 'weather/:query/' => 'weather#search', as: "weather_search"
    resources :index, concerns: :paginatable, :path => '' do
      collection do
        get ':id/', to: "articles#show", as: :articlespage
      end
    end
    resource :contact, only: [:new, :create], controller: :contact do
      get 'thankyou', to: "contact#thankyou"
    end
    get 'feed/:l', to: 'rss_feeds#index', as: "rss_feed_disp"
    resources :articles, :only => [:show], :path => '' do
      collection do
        get '/c/:id', to: "articles#related_csv"
        get "articles/feed" => 'articles#index', as: :index
        get "json/:id" => 'articles#showjson', as: :showjson
        get "related/:id" => 'articles#articleRelatedjson', as: :showrelated
        get '(:id)(/:page)', to: "articles#show", as: :show
      end
    end

    resources :articles, :except => [:show] do
      collection do
        get '(/page/:page/)', to: "articles#index", as: :articlespage
      end
    end
   # match "/en/*path" => redirect("/%{path}"), :via => [:get]
   # error pages

  end

  get 'article/:id/versions' => 'article_version#index', as: "article_version"
  get 'article/:id/versions/:v' => 'article_version#show', as: "article_version_show"

  #get 'tags/:tag', to: 'articles#index', as: "tag"
  #resources :category


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
