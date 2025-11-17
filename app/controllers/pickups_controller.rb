class PickupsController < ApplicationController
  def index
    @pickup = Pickup.find_by_title(params[:pickup])
    add_breadcrumb @pickup.title, pickup_path(@pickup)
    @articles = Article.find_by_pickup(params[:pickup]).translation_published(I18n.locale).order("published_at desc")
  end
end