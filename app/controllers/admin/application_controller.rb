class Admin::ApplicationController < ActionController::Base

  # Set layout for admin to admin
  layout "admin"
  before_action :set_locale, :check_pass_changed
  before_action :authenticate_user!
  before_action :admin_panel_authorization
  before_action :set_locale
  before_action :get_untranslated_tags
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def default_url_options(options={})
    { locale: I18n.locale }
  end
  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  def admin_panel_authorization
    if current_user.registered? || current_user.tester?
      redirect_to :root, :alert => "Access denied."
    end
  end 

  def get_untranslated_tags
    #select count(tags.id) as c from tags inner join tag_translations on tags.id = tag_id  group by tags.id having count(tags.id)<4;
    p = Tag.joins("inner join tag_translations on tags.id = tag_id").group("tags.id").having("count(tags.id) < 4")
    @missingTag = p.length
  end


  def set_locale
    if cookies[:my_locale] && I18n.available_locales.include?(cookies[:my_locale].to_sym)
      l = cookies[:my_locale].to_sym
    else
      l = I18n.default_locale
      cookies.permanent[:my_locale] = l
    end
    I18n.locale = l
  end
  def check_pass_changed
    if(current_user.nil?)
      return
    end
    if !current_user.pass_changed && params[:action] != "edit"  && params[:action] != "update"
        redirect_to edit_admin_user_path(current_user), alert: "Password change required"
    end
  end
end
