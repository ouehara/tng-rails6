require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TsunaguJapan
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')


    config.exceptions_app = self.routes
    default_url_options[:trailing_slash]= true
    config.action_controller.default_url_options = { :trailing_slash => true }
    config.assets.image_optim = false
    config.react.server_renderer_options = {
      files: ["server_side_rendering.js"], # files to load for prerendering
      replay_console: true,                 # if true, console.* will be replayed client-side
    }

    #Add Ueharah
    config.active_record.belongs_to_required_by_default = false
  end
end
