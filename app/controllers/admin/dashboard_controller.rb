class Admin::DashboardController < Admin::ApplicationController
  def index
    @activities = [] #Version.order('id desc').limit(10)
    @topImpression = [] #Article.joins(:impressions).where("impressions.created_at<='#{Time.now}' and impressions.created_at >= '#{1.week.ago}'").group("impressions.impressionable_id, articles.id").order("count(impressions.id) DESC").limit(10)
    @allImpression = [] #Article.joins(:impressions).group("impressions.impressionable_id, articles.id").order("count(impressions.id) DESC").limit(10)
    en = Article.where_translation_published.count
    zh_hant = Article.where_translation_published("zh-hant").count
    zh_hans = Article.where_translation_published("zh-hans").count
    th = Article.where_translation_published("th").count
    vi = Article.where_translation_published("vi").count
    ko = Article.where_translation_published("ko").count
    @published_article = {en: en, zh_hant: zh_hant, zh_hans: zh_hans, th: th, vi: vi, ko: ko }
  end

  def change_locale
    l = params[:locale].to_s.strip.to_sym
    l = I18n.default_locale unless I18n.available_locales.include?(l)
    cookies.permanent[:my_locale] = l
    redirect_to request.referer || admin_dashboard_url
  end
  
end
