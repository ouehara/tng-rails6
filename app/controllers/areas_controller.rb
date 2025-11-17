class AreasController < ApplicationController
  include Conf
  add_breadcrumb I18n.t('area.breadcrumb'), :area_listing_path
  def index

    @recommendedArea = getRecommendedArea
    @ad = SidebarAd.get_cached.to_json(:methods => [:banner_url])
    @root_areas = Area.roots.order(:pos)
    ids = Rails.env.development? ? [3] : [25,254,144,127,568,191,146,132,130,126]
    @related = []
      Area.find(ids).each do |el|
          val = {"link" => I18n.locale== :en ? area_path(nil,el) : area_path(I18n.locale,el), "title"=>el.name,
              "image_url" => ActionController::Base.helpers.asset_pack_path("media/images/area/popular/"+el.slug+".jpg") }

          @related << val
      end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json:  Area.all }
    end
  end

  def list_articles
      page = 1
      if(params.has_key?(:page))
        page = params[:page]
      end
      area = Area.friendly.find(params[:area])
      generate_breadcrumbCat(area)
      @restaurant = getRestaurant
      @title =  area.name
      @desc = t('area.desc')
      #SCRUM333
      area_depth = area.depth #region:0, prefecture:1, ChildArea:2
      if area_depth == 0
        area_desc = area.description unless area.description.nil?
        set_meta_tags description: area_desc
      elsif area_depth == 1
        area_desc = area.description unless area.description.nil?
        set_meta_tags description: area_desc
      elsif area_depth == 2
        area_desc = t('area.child_area_desc') % {:prefecture => area.parent.name, :child_area => area.name}
        set_meta_tags description: area_desc
      end
      #End SCRUM333
      @pagetype = "sub"
      @ad = SidebarAd.get_cached.to_json(:methods => [:banner_url])
      @curArea = area
      @areaImage = ''

      if I18n.locale.to_s == "ja" || I18n.locale.to_s == "ko"
        areatitle = @title + I18n.t("area.title_prefix")
        set_meta_tags title: areatitle
      else
        areatitle = I18n.t("area.title_prefix") + @title
        set_meta_tags title: areatitle
      end

      if area.depth	>= 2
        @areaImage = area.parent.slug
      end

      @categories_select = Category.where(id:[2,1,3,4,5,6]).joins(:articles).distinct
      fin = []
      structured = []
      @catad = {}
      @catad = @catad.to_json
      @articles = Article
      .translation_published_simple(I18n.locale)
      .page(page).per(30)
      .order("(schedule->>'#{I18n.locale}')::timestamp desc")
      .joins(:area).where(area_id: area.subtree_ids)
      @children = []
      @coupons = []

      TopPageSection.first.top_page_sections_element.each do |el|
        val = {"link" => el.link, "title"=>el.title,
        image_url: el.image_url }
        @coupons << val
      end

      Area.left_joins(:articles).group(:id).order('COUNT(articles.id) DESC').where(id: area.child_ids).each do |el|
        val = {"link" => I18n.locale== :en ? area_path(nil,el) : area_path(I18n.locale,el), "title"=>el.name}
        @children << val
      end
      @videos = Video.all.with_translations(I18n.locale).limit(3).order(:position)
      @related = []
      area.siblings.each do |el|
        #ActionController::Base.helpers.asset_pack_path("media/images/h_r/btn_hotel_en.jpg"),
        if el.id != area.id
          image = ''
          if el.depth	>= 2
            image = el.parent.slug
          end
          if(el.slug != "others" && el.slug !="nationwide")
          val = {"link" => I18n.locale== :en ? area_path(nil,el) : area_path(I18n.locale,el), "title"=>el.name,
              "image_url" => ActionController::Base.helpers.asset_pack_path("media/images/area/area_"+(image != "" ? image :  el.slug)+"M400.jpg") }

          @related << val
          end
        end
      end
      respond_to do |format|
        format.html { render file: 'articles/index' }
        format.rss { render file: 'rss/feed', :layout => false }
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
  def generate_breadcrumbCat(area)
    area.path.map do |a|
      add_breadcrumb a.name, area_path(a)
    end
  end
end
