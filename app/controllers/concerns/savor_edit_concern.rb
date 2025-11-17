module SavorEditConcern extend ActiveSupport::Concern
  def shouldAllowEdit
    if(current_user.nil?)
      return false
    end
    u = current_user
    if(u.curator? || u.administrator? || u.editor?) 
      return true
    end
  end
end