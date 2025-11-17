class Admin::PartnersController < Admin::ApplicationController
    before_action :set_partner, only: [:show, :edit, :update, :destroy, :move]

    def index
        @partners = Partner.all.order(:position)
        respond_to do |format|
            format.html
            format.js
        end
    end

    def new
        @partner = Partner.new
    end
    
    def create
        @partner = Partner.new(partner_params)
        respond_to do |format|
            if @partner.save
            format.html { redirect_to admin_partners_path, notice: 'partner was successfully created.' }
            else
            format.html { render :new }
            end
        end
    end
    
      
    def edit
    end

    def move
        @partner.move_to! params[:position]
        # render :nothing => true, :status => 200, :content_type => 'text/html'
        render body: nil
    end
      
    def update
        respond_to do |format|
            @partner.attributes = partner_params
            if @partner.save
            format.html { redirect_to admin_partners_path, notice: 'partner was successfully updated.' }
            else
            format.html { render :edit }
            end
        end
    end

    def destroy
        @partner.destroy
        respond_to do |format|
            format.html { redirect_to admin_partners_path, notice: 'partner was successfully destroyed.' }
        end
    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_partner
        @partner = Partner.find(params[:id])
    end

    def partner_params
        params.require(:partner).permit(:title, :link,  :banner,)
    end
end