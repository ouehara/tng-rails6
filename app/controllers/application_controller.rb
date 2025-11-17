class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #self.page_cache_directory = DomainCacheDirectory
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :show_admin_bar, :setup_categories, unless: :api_request?
  before_action :set_paper_trail_whodunnit, :check_pass_changed

  #before_filter :setup_sidebar, only: [:index,:show,:list_articles,:special_offer]
  add_breadcrumb "Home", :root_path

  def setup_sidebar
    if controller_name == "index"
      return
    end
    articles = Article.cached_top_articles
    tags = Tag.with_translations(I18n.locale)
          .order("article_count DESC, tags.id")
          .limit(40)
    areas = Area.sidebar_cache
    pickups = Pickup.published
    spotlight = nil
    ad = SidebarAd.get_cached
    @sidebar = {ads: ad.to_json(:methods => [:banner_url]), topArticles: articles.to_json(:methods => [:square_url]),tags: tags, areas: areas, pickup: pickups.to_json(:methods => [:medium_url]), spotlight: spotlight.to_json(:methods => [:medium_url])}
  end

  def setup_categories
    @categories = Category.cached_menu
  end

  def default_url_options
    { :locale => ((I18n.locale == I18n.default_locale) ? nil : I18n.locale) }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    if params[:locale] == I18n.default_locale.to_s
      locales = %w(en).map { |l| l.prepend '/' }
      path = request.fullpath.sub(Regexp.union(locales), '')
      path = path.end_with?("/") ? path : path+"/"
      redirect_to path, :status => 301
    end


    # if (params[:locale]  == "ja") && self.showJa
    #   redirect_to  url_for(locale: 'en')
    # end
  end

  def current_translations
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    translations ||= I18n.backend.send(:translations)
    @translations = {savor: translations[I18n.locale]["savor"]}

  end


  def showJa
    if(current_user.nil?)
      return true
    end
    if User.roles[current_user.role] > User.roles[:registered]
      return false
    end
    return true
  end

  def show_admin_bar
    @show_bar = false
    if(current_user.nil?)
      return
    end
    if User.roles[current_user.role] <= User.roles[:tester]
      return
    end
    @show_bar = true
  end

  def api_request?
    request.format.json? || request.format.rss? || request.format.csv?
  end

  def check_pass_changed
    if(current_user.nil?)
      return
    end
    unless current_user.pass_changed
      redirect_to edit_admin_user_path(current_user), alert: "Password change required"
    end
  end

  #def record_not_found
  #  redirect_to root_path
  #end
end
