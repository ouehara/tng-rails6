class UsersController < ApplicationController
  include ViewUserPageConcern
  def list_articles
    page = 1
    if !admin_only
      render template: "errors/404",status: 404
      return
    end
    if(params.has_key?(:page))
      page = params[:page]
    end
    u = User.find_by_username(params[:author])
    @title = u.username
    @desc = u.description
    if u.has_page == 0
      render template: "errors/404",status: 404
    else
      @articles = u.articles.translation_published_simple(I18n.locale).where(:article_users => {:lang => I18n.locale})
      .page(page).per(Rails.configuration.elements_per_page).order("(schedule->>'#{I18n.locale}')::timestamp desc")
      render "articles/index"
    end
  end
end