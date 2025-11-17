class VideoController < ApplicationController
    add_breadcrumb I18n.t("video"), :video_index_path
    def index
      @pagetype="index"
      @autoplay=""
      if params.has_key?(:play)
        @autoplay=params[:play]
      end
      page = 1
      page = params[:page] unless !params.has_key?(:page)
      @videos = Video.all.with_translations(I18n.locale).order(:position).page(page).per(15).order(:position)
    end
  end
