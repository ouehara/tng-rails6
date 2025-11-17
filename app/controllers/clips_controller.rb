class ClipsController < ApplicationController
    add_breadcrumb I18n.t("clips_title"), :clips_path
    def index
        @articles = Article.translation_published_simple(I18n.locale).order("(schedule->>'#{I18n.locale}')::timestamp desc, id desc").limit(3)
        @articles = @articles.to_json(:methods => [:thumb_url, :cached_users])
    end
end
