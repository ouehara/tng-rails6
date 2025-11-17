class Api::PlacesController < ApplicationController

  def index
    @establishment = HotelLandingpage.with_translations(I18n.locale).where(published: true)
    @establishment = @establishment.c_hotel
    # render json: @establishment
    # render 'index', formats: 'json', handlers: 'jbuilder'
    render 'index', formats: 'json', handlers: 'jbuilder'
  end

end