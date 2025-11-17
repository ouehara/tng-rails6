class Api::Adapters::PixtaController < ApplicationController
  before_action :set_adapter

  def category_list
    res = @client.category_list
    render json: res
  end

  def category_search
    res = @client.category_search(params[:category_id])
    render json: res
  end

  def search
    res = @client.search(params[:query])
    render json: res
  end

  def image_details
    res = @client.image_details(params[:id])
    render json: res
  end

  def download
    res = @client.download(params[:id], params[:size])
    render json: res
  end

  private
  def set_adapter
    @client = PixtaAdapter.new
  end
end