class Admin::CuratorRequestsController < Admin::ApplicationController
  include AdminOnlyConcern
  before_action :set_curator_request, only: [:show, :destroy, :accept, :reject]
  before_action :set_ransack_search_object

  # GET /admin/curator_requests
  # GET /admin/curator_requests.js
  # @param [String] order Order
  # @param [String] page Pagination
  def index
    @curator_requests = @q.result(distinct: true).order('id desc').page(params[:page])

    respond_to do |format|
      format.html { render }
      format.js { render }
    end
  end

  # GET /admin/curator_requests/1
  # GET /admin/curator_requests/1.json
  def show
  end

  # DELETE /admin/curator_requests/1
  # DELETE /admin/curator_requests/1.json
  def destroy
    @curator_request.destroy
    respond_to do |format|
      format.html { redirect_to admin_curator_requests_url, notice: 'Curator Request was successfully destroyed.' }
    end
  end

  # PATCH /admin/curator_requests/1/accept
  def accept
    @curator_request.accept!
    respond_to do |format|
      format.html { redirect_to [:admin, @curator_request], notice: 'Curator request was accepted!' }
    end
  end

  # PATCH /admin/curator_requests/1/reject
  def reject
    @curator_request.rejected!
    respond_to do |format|
      format.html { redirect_to [:admin, @curator_request], alert: 'Curator request was rejected!' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_curator_request
    @curator_request = CuratorRequest.find(params[:id])
  end

  # Set ransack search object
  def set_ransack_search_object
    @q = CuratorRequest.ransack(params[:q])
  end
end
