class Admin::ArticleGroupingFavoritesController < Admin::ApplicationController
  def index
    @favorites = ArticleGroupingFavorite.new
    @categories = ArticleGroup.get_sorted
    respond_to do |format|
      format.js
    end
  end

  def create
    @fav = ArticleGroupingFavorite.new(fav_params)
    respond_to do |format|
      if @fav.save
        format.html { redirect_to admin_article_groups_url, notice: 'Favorite was created' }
        # format.json { render :show, status: :created, location: @area }
      else
        format.html { render :new }
        # format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def fav_params
    params.require(:article_grouping_favorite).permit(:group_1, :group_2,:group_3,:group_4)
  end
end