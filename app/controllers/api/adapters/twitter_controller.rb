class Api::Adapters::TwitterController < ApplicationController

  before_action :set_adapter

  # GET /api/adapters/tweeter/search.json
  # @see twitter_adapter.rb class
  def search
    query = params[:query]
    params.delete :query
    tweets = @client.search(query, params)
    render json: tweets
  end

  private

  def set_adapter
    @client = TwitterAdapter.new
  end

end
