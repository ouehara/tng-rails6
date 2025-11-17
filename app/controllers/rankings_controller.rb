class RankingsController < ApplicationController
  def index
  page = 0
    if(params.has_key?(:page))
      page = params[:page]
    end
    @title = t('rankings.title')
    @desc = t('rankings.desc')
    @articles = Article.translation_published(I18n.locale).page(1).per(Rails.configuration.elements_per_page).order(impressions_count: :desc, id: :desc)
    add_breadcrumb "Ranking", :rankings_path
    render "articles/index"
  end
end