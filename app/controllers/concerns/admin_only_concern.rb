module AdminOnlyConcern extend ActiveSupport::Concern
  included do
    before_action :admin_only
  end
  
  private
    def admin_only
      unless !current_user.nil? && current_user.administrator?
       redirect_to :back, :alert => "Access denied."
      end
    end
end