# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
#Rails.application.config.assets.precompile += %w( admin/admin.css admin/admin.js )
#Rails.application.config.assets.precompile += %w( react-server.js area.js)
#Rails.application.config.assets.precompile += %w( application_admin.css )
#Rails.application.config.assets.precompile += %w( translation_center/loading.gif )
#Rails.application.config.assets.precompile += %w( locales/*.css )
#Rails.application.config.assets.precompile += %w( print.css )
#Rails.application.config.assets.precompile += %w( custom_lightbox.css )
#Rails.application.config.assets.precompile += %w( lightbox/* )
#Rails.application.config.assets.precompile +=%w( server_side_rendering.js )

#Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf|otf)$/
# tngレポジトリから追加 start
Rails.application.config.assets.precompile += %w( jquery.js )
Rails.application.config.assets.precompile += %w( paginathing.js )
# Rails.application.config.assets.precompile += %w( pagination.js )
Rails.application.config.assets.precompile += %w( readmore.js )
# tngレポジトリから追加 end