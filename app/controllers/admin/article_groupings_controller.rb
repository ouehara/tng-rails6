class Admin::ArticleGroupingsController < Admin::ApplicationController
  def destroy
    #grouping = ArticleGrouping.where(article_group_id: params[:article_group_id]).where(article_id: params[:id]).first
    articlegroup = ArticleGroup.find(params[:article_group_id])
    articlegroup.articles.delete(Article.find(params[:id]))

    #grouping.destroy
    respond_to do |format|
      format.html { redirect_to admin_article_groups_url, notice: 'Area was successfully destroyed.' }
    end
  end
end
