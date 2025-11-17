class CategoryController < ApplicationController
  include Conf
  # POST /category
  # POST /category.json
  def index
    page = 1
    
    @recommendedArea = getRecommendedArea
    @ad = SidebarAd.get_cached.to_json(:methods => [:banner_url])
    if(params.has_key?(:page))
      page = params[:page]
    end 
    @category = Category.friendly.find(params[:category])
    generate_breadcrumbCat(@category)
    if (@category.seo_title)
      @title = @category.seo_title
    else
      @title = @category.name
    end
    #@title = @category.name

    @pagetype = "index"
    @desc = @category.description
    @groups = TagGroup.cached_categroy(@category.id)
    @activeGroup = nil
    @groupSlug = ""
    if params.has_key?(:group)
      
      @activeGroup = TagGroup.friendly.find(params[:group])
      @groupSlug = "g/"+@activeGroup.slug
      articles = @activeGroup.articles.translation_published_simple(I18n.locale)
      .page(page).per(30).order("(schedule->>'#{I18n.locale}')::timestamp desc")
    else
    articles  = Article.where(category_id: @category.subtree_ids)
    .translation_published_simple(I18n.locale)
    .page(page).per(30).order("(schedule->>'#{I18n.locale}')::timestamp desc")
    end

    @area= ""
    @weather = {}
    @areaslug = ""
    @rootArea = ""
    @metaTitle = ""
    @a = nil
    @select_area = nil
    subtitle =  I18n.t 'japan'
   # add_breadcrumb @category.name, categoryListing_path(@category)
    if(params.has_key?(:area))
      
      area = Area.friendly.find(params[:area])
      generate_breadcrumb(area)
      @select_area = area
      @a = area
      @area = area.name
      if area.slug != "nationwide" &&  area.slug != "others"
        @areaslug = area.slug
      end
      if area.depth	>= 2
        @rootArea = area.root.slug
        @areaslug = area.parent.slug
      else
        @rootArea = area.slug
      end
      @weather = Weather.cached_weather(area.name)
      @pagetype = "sub"
      @curArea = area 
      
      areaids = []
      areaids = [area.id]
      if area.children.length > 0
        areaids << get_area_ids(area.children,areaids)
      end
      subtitle = area.name
      @articles = articles.translation_published_simple(I18n.locale).page(page).per(30).order("published_at desc").joins(:area).where(area_id: areaids)

      @metaTitle = @title  %  {:area => area.name }
      @title = @title  %  {:area => '' }
    else
      @articles = articles
      prefix=""
      if I18n.locale.to_s == "en"
        prefix = "in "
      end
      @title = @title  %  {:area => prefix+subtitle}
      @metaTitle = @title
    end
    
    @catad = {}
    if(@category.id==3 && I18n.locale.to_s != "id")
      @catad = {
      "img" => ActionController::Base.helpers.asset_pack_path("media/images/h_r/btn_hotel_en.jpg"),
      "alt"=> "tsunagu Japan's Editorial Team's Top Picks! Japanese Hotels Inns",
      "url"=> "/"+I18n.locale.to_s+"/category/hotels-ryokan/recommended/"
      }
    end

    if(@category.id==2  && I18n.locale.to_s != "id")
      @catad = {
      "img" => ActionController::Base.helpers.asset_pack_path("media/images/tour/#{I18n.locale}.png"),
      "alt"=> "tsunagu Japan's Editorial Team's Top Picks! Japanese Hotels Inns",
      "url"=> "/"+I18n.locale.to_s+"/tour/"
      }
    end
    @catad = @catad.to_json
    
    @desc = @desc.nil? ? "" : @desc % {:area => subtitle}
    @maxPage = @articles.total_pages

    if(@maxPage.to_i < page.to_i && @maxPage.to_i > 0)
      raise ActionController::RoutingError.new('Not Found')
    end
    @rss = @category.articles.translation_published_simple(I18n.locale).find_in_batches(batch_size: 500)
    @pagination = @articles 
    @articles = @articles.to_json(:methods => [:thumb_url, :cached_users])
    if @select_area.nil?
      @select_area = {name: "Area",children: Area.roots}
    end
    if @pagination.length == 0
      set_meta_tags noindex: true
    end

    #SCRUM309
    category_depth = @category.depth # ex. 0:Food&Drinks, 1:RestaurantTypes, 2:Izakaya
    category_parent = @category.parent
    article_cnt = articles.total_count
    @category_desc = @desc

    if category_depth == 1 # Category 2 (e.g. Activities)
      if @category.has_children? # Cat2s with child cat3s
        category_child = @category.children.first(3).pluck('name')
        children_name = category_child.join(", ")
        @category_desc = t('category.cat2_with_child_cat3_desc') % {
          :cat2_alias => @category.name, # ex. Activities
          :N => article_cnt,
          :cat3 => children_name # ex. Cruises, Hair salons, Beauty salons
        }
      else # Cat2s without child Cat3s
        @category_desc = t('category.cat2_without_child_cat3_desc') % {
          :cat2_alias => @category.name, # ex. Ryokan
          :N => article_cnt,
          :parent_cat1 => category_parent.name # ex. Accommodation
        }
      end
    elsif category_depth == 2 # Category 3 (e.g. Cruise)
      if article_cnt >= 2 # Cat3 with 2 and more articles
        @category_desc = t('category.cat3_with_2_and_more_articles') % {
          :cat3_alias => @category.name, # ex. Cruises
          :N => article_cnt,
          :parent_cat2 => category_parent.name # ex. Activities
        }
      elsif article_cnt == 1 # Cat3 with only 1 article
        @category_desc = t('category.cat3_with_only_1_article') % {
          :cat3_alias => @category.name, # Pizza
          :parent_cat2 => category_parent.name # Sweets & snacks
        }
      end
    end
    #End SCRUM309

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @articles }
      format.rss { render file: 'rss/feed', :layout => false }
    end
  end

  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        format.json {render json: @category, status: :created }
      else
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def category_params
    params.fetch(:category, {}).permit(:name)
  end

  def sort_root_area_list(article_list)
    article_list.map do |area|
      #if area.area.has_children? 
        @availAreas << area.area.id
        if area.area.parent_id != area.area.root_id 
          @availAreas << area.area.parent_id
        end
      #end
    end
  end
  def get_area_ids(arealist, ids)
    arealist.each do |a|
      ids << a.id
      if(a.has_children?)
        get_area_ids(a.children,ids)
      end
    end
    return arealist
  end
  def get_area_list(areaids,curArea,res)
    list = Area.joins(:articles).group('areas.id, articles.area_id').where("articles.category_id= #{@category.id}" ).where(id: areaids)
    list.each do |a|
    if(a.depth !=curArea.depth && a.depth-1 != curArea.depth)
      res.add(a.parent)
    end
    if(a.depth !=curArea.depth && a.depth-1 == curArea.depth) 
      res.add(a)
    end
    end
    return res
  end
  def generate_breadcrumb(area)
    area.path.map do |a|
      add_breadcrumb a.name, categoryListing_path(@category,a)
    end
  end
  def generate_breadcrumbCat(cat)
    cat.path.map do |a|
      add_breadcrumb a.name, categoryListing_path(a)
    end
  end
end