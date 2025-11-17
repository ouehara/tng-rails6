class CuratorRequestController < ApplicationController

  # Require login
  before_action :authenticate_user!

  def new
    @curator_request = CuratorRequest.new
  end

  def create
    @curator_request = CuratorRequest.new(curator_request_params)
    @curator_request.user = current_user
    respond_to do |format|
      if @curator_request.save
        format.html { redirect_to action: :thankyou, notice: 'Request was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private

  def curator_request_params
    params.require(:curator_request).permit(:message)
  end
end
