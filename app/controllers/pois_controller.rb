class PoisController < ApplicationController
  include HotelApiConcern
  before_action :set_adapter
  #http://localhost:3000/pois/poi:55165
  def show
   if !shouldAllowSearch
    redirect_to [:user_session], :alert => "Access denied."
    return
   end
   @poi = @client.find(params[:id])
  end

  private 
  def set_adapter
    @client = PoiAdapter.new
  end

end