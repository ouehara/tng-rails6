source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.1'

# Use PostgreSQL as the database
gem 'pg', '~> 0.18'

# Use SCSS for stylesheets
gem 'sass-rails'

# Use bootstrap for css framework
gem "bootstrap-sass"
gem 'paperclip-globalize3', '~> 4.0'
# Use Compass for css generater
#gem "compass-rails"

# Use bower for frontend package management
gem "bower-rails", "~> 0.10.0"
gem 'grpc'
#gem "oink"
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 4.2.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.4.0'
gem 'jquery-ui-rails', '~> 6.0.0'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 2.2.0', group: :doc

gem 'globalize-accessors', '~> 0.3.0'

# Use Devise for User Authentication
gem 'devise', '~> 4.8.0'

gem 'devise-i18n', '~> 1.10.0'

# meta tags
gem 'meta-tags', '~> 2.16.0'

#react rails
gem 'webpacker', '~> 5.4.3'
gem 'react-rails', '~> 2.6.1'
gem "autoprefixer-rails", '~> 10.3.3.0'
# Use ancestry management for Tag
gem 'ancestry', '~> 4.1.0'
gem 'sortable_tree_rails', '~> 0.0.10'
gem 'haml', '~> 5.2.2'

# Use Kaminari for Pagination
gem 'kaminari', '~> 1.2.1'


# Use Twitter API
gem 'twitter', '~> 7.0.0'

# Use Pundit for Authorization
gem 'pundit', '~> 2.1.1'
# seo urls
gem 'friendly_id', '~> 5.4.2'
gem 'friendly_id-globalize', '1.0.0.alpha3'

# dup
gem 'amoeba', '~> 3.2.0'


# Use Ransack for Search
gem 'ransack', '~> 2.4.2'

# Use cocoon for dynamic nested forms
gem 'cocoon', '~> 1.2.15'

# Use paperclip for Image Uploader
gem 'paperclip', "~> 6.1.0"
#gem 'paperclip-compression'
gem 'paperclip-optimizer', "~> 2.0.0"

# Use omniauth for Social Login
gem 'omniauth', "~> 2.0.4"
gem 'omniauth-facebook', "~> 8.0.0"
gem 'omniauth-twitter', "~> 1.4.0"

# Use annotate for schema comments
gem 'annotate', "~> 3.1.1"

gem 'aws-sdk', '~> 3.1'

#count page impressions
gem 'impressionist', '~> 2.0.0'
gem 'canonical-rails', '~> 0.2.12'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

#full text search
# gem 'pg_search'
#gem 'where-or'

#meta tags
gem 'meta-tags', '~> 2.16.0'
# Use Puma as the app server for Rails 6
gem 'puma', '~> 5.6'
# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

#edit history for posts
gem 'paper_trail', '~> 12.1.0'

gem "breadcrumbs_on_rails", '~> 4.1.0'

gem 'globalize', '~> 5.3.1'

gem "browser", '~> 5.3.1'
# http 
gem "httparty", '~> 0.20.0'
gem 'mini_racer', '0.3.1'
#caching
#gem "actionpack-page_caching"

#sorting
gem 'activerecord-sortable', '~> 0.0.8'
gem 'jquery-ui-rails', '~> 6.0.0'

gem 'dalli', '~> 3.0.3'
gem 'connection_pool', '~> 2.2.5'
gem 'lightbox2-rails', '~> 2.8.2.1'

gem 'nokogiri', '~> 1.12.5'
gem 'sitemap_generator', '~> 6.1.2'
gem "fog-aws", '~> 3.12.0'

gem 'rbtrace', '~> 0.4.14'
gem 'stackprof', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.1.3'
  gem 'get_process_mem', '~> 0.2.7'
  # Database ER diagram generator
  gem 'rails-erd', '~> 1.6.1'

  # Documentation
  gem 'yard', '~> 0.9.26'
  gem 'derailed_benchmarks', '~> 2.1.1'
  # Use RSpec for Test Framework
  gem "rspec-rails", "~> 5.0.2"
  gem "factory_bot_rails", "~> 6.2.0"
  gem 'guard-rspec', '~> 4.7.3'
  gem 'spring-commands-rspec', '~> 1.0'
  gem "faker", "~> 2.19.0"
  gem 'rack-mini-profiler', "~> 2.3.3"
  gem 'memory_profiler', "~> 1.0.0"
  gem 'bullet', "~> 6.1.5"
  gem "rubycritic", :require => false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', "~> 3.0.0"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 4.1.0'
end

group :test do
  # Use Capybara for FeatureSpecs
  gem "capybara", "~> 2.7"

  # Use Database Cleaner for testing
  gem "database_cleaner", "~> 1.5"
  gem "launchy", "~> 2.4"

  # Use Javascript Web client for testing
  gem "selenium-webdriver", "~> 2.52"

  # Use Shoulda Mather
  gem 'shoulda-matchers', '~> 3.0'
end
