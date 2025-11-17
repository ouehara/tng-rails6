class SavorRestaurantController < ApplicationController
  before_action :set_restaurant, only: [:update]
  add_breadcrumb I18n.t("savor.restaurant_search"), :restaurant_search_path
  include SavorEditConcern
  def update
    if !shouldAllowEdit
      return false
    end
    
    @restaurant.update(restaurant_params)
    respond_to do |format|
      # format.all { render :nothing => true, :status => 200,:content_type => 'text/html' }
      format.all { render body: nil }

    end
  end

  private
  
  def set_restaurant
      @restaurant = SavorRestaurant.find(params[:id])
  end

  def restaurant_params
    params.require(:savor_restaurant).permit(:ad)
  end
end