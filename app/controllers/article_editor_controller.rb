class ArticleEditorController < ApplicationController
  def remove_lock
    if editArt = ArticleEditor.where(:articles_id => params[:id]).first
      ArticleEditor.delete_all(:articles_id =>  params[:id])
    end
  end

  def ping
     if editArt = ArticleEditor.is_editing(params[:id])
       if editArt.users_id == current_user.id
         editArt.touch
       else
         render json: "{\"notification\": \"#{editArt.user.username} started editing\"}"
         return
       end

     end
     # render :nothing => true
     render body: nil
  end

end