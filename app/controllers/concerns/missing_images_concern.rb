module MissingImagesConcern extend ActiveSupport::Concern
  included do
    before_action :view_permit
  end
  
  private
  def view_permit
    if(current_user.nil?)
     return
    end
    unless current_user.administrator? || current_user.editor?
      redirect_to :back, :alert => "Access denied."
    end
  end
end