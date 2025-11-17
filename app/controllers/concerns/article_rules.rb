module ArticleRules extend ActiveSupport::Concern
  included do
    before_action :only_permit, :only => [:edit, :delete, :update]
  end

  def autorize(article)
    if(current_user.nil?)
      redirect_to [:admin, :dashboard], :alert => "Access denied."
      return false
    end
    if(current_user.curator?)
      if article.user_id != current_user.id
        redirect_to [:admin, :dashboard], :alert => "Access denied."
        return false
      end
      return true
    end
    if(current_user.editor?) 
      return true
    end
    if(current_user.administrator?) 
      return true
    end
    redirect_to :root, :alert => "Access denied."
  end

  def autorize_new
    if(!authenticate_user!) 
      redirect_to :root, :alert => "Access denied."
      return false
    end

    u = current_user
    if(u.curator? || u.administrator? || u.editor?) 
      return true
    end
  end

  def autorize_bulk_action
    u = current_user
    if(u.administrator?) 
      return true
    end
    return false
  end

  private
    def only_permit
        if(current_user.nil?)
         return
        end
        unless current_user.administrator? || current_user.curator? || current_user.editor?
          redirect_to :back, :alert => "Access denied."
        end
    end
end
