module ViewUserPageConcern extend ActiveSupport::Concern
    def admin_only
      unless !current_user.nil? && current_user.administrator?
        return false
      end
      return true
    end
end