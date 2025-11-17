class ApiController < ApplicationController

  def places
    @establishment = HotelLandingpage.with_translations(I18n.locale).where(published: true)
    @establishment = @establishment.c_hotel


    render 'places', formats: 'json', handlers: 'jbuilder'

    # id
    # render json: Area.find([472, 282, 152, 125, 74, 299, 420, 199, 238, 1, 101, 435, 454, 447, 311, 226, 188])
    #
    # vi
    # render json: Area.find([472, 282, 152, 125, 74, 299, 420, 199, 238, 1, 101, 435, 454, 447, 311, 226, 188])

  end

end