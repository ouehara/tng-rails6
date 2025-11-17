class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end
  def list_articles
    page = 1
    if(params.has_key?(:page))
      page = params[:page]
    end
    f = TagToCat.find_by_slug(params[:tag])
    if !f.nil?
      redirect_to category_path(I18n.default_locale ,f.category), status: :moved_permanently
      return
    end
    tag = Tag.friendly.find(params[:tag]);

    @t = tag
    @title = tag.name
    @meta_title = t('tags.meta_title') % {:tag => tag.name} #SCRUM333
    @desc =  tag.description  %  {:tag => tag.name} unless tag.description.nil?
      @desc = t('tags.desc') %  {:tag => tag.name} unless !@desc.nil?


    add_breadcrumb params[:tag], :tag_path

    @articles = tag.articles.group(:article_id, "articles.id").tagged_with(params[:tag]).translation_published(I18n.locale).page(page).per(Rails.configuration.elements_per_page).order("(schedule->>'#{I18n.locale}')::timestamp desc")
    @maxPage = @articles.total_pages
    #SCRUM333
    cnt = @articles.total_count
    if cnt >= 2
      @meta_desc = t('tags.multi_meta_desc') % {:tag => tag.name, :N => cnt}
    else
      @meta_desc = t('tags.single_meta_desc') % {:tag => tag.name}
    end
    #End SCRUM333
    @ad = SidebarAd.get_cached.to_json(:methods => [:banner_url])

    @wowjapan = false
    if @title == "W.JAPAN"
      @wowjapan = true
    end

    respond_to do |format|
      format.html
      format.json { render json: @articles }
      format.rss { render file: 'rss/feed', :layout => false }
    end
  end
end
