class Admin::ToursController < Admin::ApplicationController
    before_action :set_tour, only: [:show, :edit, :update, :destroy, :move]

    def index
        @tours = Tour.all.order(:position)
        respond_to do |format|
            format.html
            format.js
        end
    end

    def new
        @tour = Tour.new
        @tour.buttons = []
        @tour.build_buttons
    end
    
    def create
        @tour = Tour.new(tour_params)
        respond_to do |format|
            if @tour.save
            format.html { redirect_to admin_tours_path, notice: 'Tour was successfully created.' }
            else
            format.html { render :new }
            end
        end
    end
    
      
    def edit
    end

    def move
        @tour.move_to! params[:position]
        # render :nothing => true, :status => 200, :content_type => 'text/html'
        render body: nil
    end
      
    def update
        respond_to do |format|
            @tour.attributes = tour_params
            if @tour.save
            format.html { redirect_to admin_tours_path, notice: 'Tour was successfully updated.' }
            else
            format.html { render :edit }
            end
        end
    end

    def destroy
        @tour.destroy
        respond_to do |format|
            format.html { redirect_to admin_tours_path, notice: 'Tour was successfully destroyed.' }
        end
    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
        @tour = Tour.find(params[:id])
    end

    def tour_params
        params.require(:tour).permit(:title, :banner, :price, :duration, :details,:area_id, buttons_attributes: [:btn, :link, :_destroy])
    end
end