host = 'localhost'
Rails.application.routes.default_url_options[:host] = host

Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
  config.webpacker.check_yarn_integrity = true

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  #config.consider_all_requests_local = true #[rails6オリジナル コメント化　20211103]

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true #[tngレポジトリから追加 20211103]
  config.action_controller.perform_caching = false #[tngレポジトリから追加 20211103]

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    #config.action_controller.perform_caching = true #[rails6オリジナル コメント化　20211103]
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    # config.cache_store = :null_store

    # Memcached設定（ElastiCache使用）
    config.cache_store = :mem_cache_store, "#{ENV['MEMCACHED_ENDPOINT']}:#{ENV['MEMCACHED_PORT']}"
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  #config.active_storage.service = :local #[rails6オリジナル コメント化　20211103]

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # ロードバランサーのドメインを追加(TODO 修正)
  config.hosts << /\A[a-z0-9\-]+\.us-west-2\.elb\.amazonaws\.com\z/
  # ローカルテスト用
  config.hosts << "localhost"
  config.hosts << "tng-dev.sukejima.com"

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.assets.compress = true #[tngレポジトリから追加 20211103]
  config.assets.js_compressor = :uglifier #[tngレポジトリから追加 20211103]
  config.assets.css_compressor = :scss #[tngレポジトリから追加 20211103]
  # config.assets.compile = false
  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true #[tngレポジトリから追加 20211103]

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true #[tngレポジトリから追加 20211103]

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true
  # Mail Settings
  config.action_mailer.raise_delivery_errors = true #[tngレポジトリから追加 20211103]
  config.action_mailer.perform_deliveries = true #[tngレポジトリから追加 20211103]
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } #[tngレポジトリから追加 20211103]

  #react config
  config.react.variant = :development #[tngレポジトリから追加 20211103]
  config.react.addons = true #[tngレポジトリから追加 20211103]

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.i18n.fallbacks = [:en] #[tngレポジトリから追加 20211103]
  config.action_mailer.delivery_method = :smtp #[tngレポジトリから追加 20211103]
  config.action_mailer.smtp_settings = {
    :user_name => ENV['TNG_SENDER_USERNAME'], #[tngレポジトリから追加 20211103]
    :password => ENV['TNG_SENDER_PASSWORD'], #[tngレポジトリから追加 20211103]
    :domain => ENV['TNG_SENDER_DOMAIN'], #[tngレポジトリから追加 20211103]
    :address => ENV['TNG_SENDER_DOMAIN'], #[tngレポジトリから追加 20211103]
    :port => '587', #[tngレポジトリから追加 20211103]
    :authentication => 'plain', #[tngレポジトリから追加 20211103]
    :enable_starttls_auto => true #[tngレポジトリから追加 20211103]
  }
  config.paperclip_defaults = {
    storage: :s3, #[tngレポジトリから追加 20211103]
    s3_protocol: :https, #[tngレポジトリから追加 20211103]
    s3_host_alias: ENV['CLOUDFRONT_DOMAIN'], #[tngレポジトリから追加 20211103]
    s3_credentials: {
      s3_host_alias: ENV['CLOUDFRONT_DOMAIN'], #[tngレポジトリから追加 20211103]
      bucket: ENV['TNG_S3_BUCKET'], #[tngレポジトリから追加 20211103]
      access_key_id:  ENV['TNG_AWS_ACCESS_KEY_ID'], #[tngレポジトリから追加 20211103]
      secret_access_key: ENV['TNG_AWS_SECRET_ACCESS_KEY'], #[tngレポジトリから追加 20211103]
      s3_region: ENV['TNG_AWS_S3_REGION'], #[tngレポジトリから追加 20211103]

    },
  }
  config.elements_per_page = 9 #[tngレポジトリから追加 20211103]

  config.after_initialize do
    Bullet.enable = true #[tngレポジトリから追加 20211103]
    Bullet.rails_logger = true #[tngレポジトリから追加 20211103]
    Bullet.add_footer = true #[tngレポジトリから追加 20211103]
  end

  # Add ueharah
  # config.action_controller.include_all_helpers = true
end
