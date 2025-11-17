class Admin::ArticleGroupsController < Admin::ApplicationController
  before_action :set_lang, only: [:edit, :update]
  before_action :find_article_group, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit, :update, :destroy]
  include SortableTreeController::Sort
  sortable_tree 'ArticleGroup', {parent_method: 'parent'}

  def show
    arr = [params[:id]]
    arr << params[:filter_1] if params[:filter_1].present?
    arr << params[:filter_2] if params[:filter_2].present?
    arr << params[:filter_3] if params[:filter_3].present?
    @articles = Article.in_groupings(arr)

    @items = ArticleGroup.get_sorted
  end

  def index
    # get items to show in tree
    @items = ArticleGroup.all.arrange(:order => :pos)
    @favorites = ArticleGroupingFavorite.all
  end

  def edit
    #    <%= f.select :parent_id, @categories %>
  end

  def new
    @article_group = ArticleGroup.new
  end

  def delete_connection

  end

  def create
    @article_group = ArticleGroup.new(article_group_params)
    respond_to do |format|
      if @article_group.save
        format.html { redirect_to admin_article_groups_url, notice: 'Area was successfully created.' }
        # format.json { render :show, status: :created, location: @area }
      else
        format.html { render :new }
        # format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end

  end

  def edit
  end

  def update
    if @article_group.update(article_group_params)
      redirect_to  admin_article_groups_url
    else
      render 'edit'
    end
  end

  def destroy
    @article_group.destroy
    respond_to do |format|
        format.html { redirect_to admin_article_groups_url, notice: 'Area was successfully destroyed.' }
    end
  end

  def pick_article
    @q = Article.ransack(params[:q])
    respond_to do |format|
      format.js
    end
  end

  def pick_article_search
    @q = Article.full_text_search(query: params[:disp_title]).translation_published(I18n.locale)
    respond_to do |format|
      format.js
    end
  end

  def add_articles
    group = ArticleGroup.where(id: params[:article_groups].split(/,/))
    article = Article.where(id: params[:articleId].split(/,/))
    article.each do |a|
      a.article_groupings.delete_all
      group.each do |g|
        a.article_groupings.create(:article_group => g)
      end
    end
    redirect_to  admin_article_groups_url
  end

  private
  def set_lang
    if(params[:lang])
      I18n.locale = params[:lang]
    else
      I18n.locale = :en
    end
  end

  def article_group_params
    params.require(:article_group).permit(:title, :parent_id)
  end

  def find_article_group
    @article_group = ArticleGroup.find(params[:id])
  end

  def set_categories
    @categories = ArticleGroup.get_sorted
  end

end
