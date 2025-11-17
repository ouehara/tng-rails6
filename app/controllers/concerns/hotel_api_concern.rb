module HotelApiConcern extend ActiveSupport::Concern
  def shouldAllowSearch
    if(current_user.nil?)
      return false
    end
    u = current_user
    if(u.curator? || u.administrator? || u.editor?) 
      return true
    end
  end
end