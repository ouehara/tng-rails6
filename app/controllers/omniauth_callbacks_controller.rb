class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def callback_for_all_providers
    # Check if Omniauth is available
    auth = env["omniauth.auth"]
    unless auth.present?
      flash[:danger] = "Authentication data was not provided"
      redirect_to root_url and return
    end

    # Set provider name (set with alias method name)
    provider = __callee__.to_s

    user = OAuth::OAuthService::GetOAuthUser.call(auth, current_user)

    if user.persisted? && user.email_verified?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      user.reset_confirmation!
      flash[:warning] = "We need your email address before proceeding."
      redirect_to admin_dashboard_path
    end
  end

  alias_method :facebook, :callback_for_all_providers
end
