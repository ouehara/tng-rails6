class Admin::FlushCachesController < Admin::ApplicationController
    include AdminOnlyConcern
    def flush
        #I18n.available_locales.each do |lang|
        #    Rails.cache.delete("top-articles-#{lang}")
        #end
        render json: { done: true }
    end



  end
  