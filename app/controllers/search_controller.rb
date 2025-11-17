class SearchController < ApplicationController
  def list_articles
    page = 1
    if(params.has_key?(:page))
      page = params[:page]
    end
    @pagetype='index'
    @title = t('search.title')
    #@articles = Article.translation_published(I18n.locale).order("RANDOM()")
    @articles = Article.full_text_search(query: prepare_query).translation_published(I18n.locale)
    
    if params.has_key?(:category) && params[:category] != 0
      @articles = @articles.where(category_id: params[:category])
    end
    if params.has_key?(:area) && params[:area] != 0
      @articles = @articles.where(area_id: params[:area])
    end
    @more = {path:  request.path}    
    
    @ad = SidebarAd.get_cached.to_json(:methods => [:banner_url])
    @articles = @articles.page(page).per(Rails.configuration.elements_per_page).order("published_at desc")
    @maxPage = @articles.total_pages
    @desc = t('search.desc',num: @articles.total_count, term: prepare_query)
    #@articles = @articles.to_json(:methods => [:thumb_url, :cached_users])
    respond_to do |format|
      format.html { render "search/list_articles" }
      format.json { render json: @articles}
    end
  end

  private

  def prepare_query
    params[:search]
  end
end