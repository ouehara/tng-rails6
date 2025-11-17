class ArticleVersionController < ApplicationController
#before_action :set_article only: [:show]
before_action :get_article ,:get_versions, only: [:show, :index]
include ArticleRules
def index
  respond_to do |format| 
    format.json { render json: @articleVersions }
  end
end

def show
  @article = @articleVersions.find(params[:v]).reify
  # override lock and status
  @article.optimistic_lock = @orig.optimistic_lock
  @article.is_translated = @orig.is_translated
  @article.schedule = @orig.schedule
  # end override lock and status
  # @tag = Tag.order("id").all.includes(:translations)
  @category = Category.all.includes(:translations)
  autorize(@article)
  @area = Area.includes(:translations).order(:pos ,:names_depth_cache)
  render 'articles/edit'
end

private
    # Use callbacks to share common setup or constraints between actions.
    def get_article
      @orig = Article.find(params[:id])
    end
    def get_versions
      @articleVersions = @orig.versions
    end
end