class HotelsController < ApplicationController
  include HotelApiConcern
  def search
    if !shouldAllowSearch
      render json: []
      return
    end
    hotels = Hotel.by_name_like(search_params[:query]).includes(:hotel_details)
    render json: hotels.to_json(:include => :hotel_details)
  end

  def show
    if current_user.nil?
      redirect_to :back, :alert => "Access denied."
      return
    end
    @hotels = Hotel.find(show_params[:id])
  end

  private
  def search_params
    params.permit(:query)
  end
  def show_params
    params.permit(:id)
  end
  
end