class Admin::TagGroupsController < Admin::ApplicationController
    before_action :set_tg, only: [:show, :edit, :update, :destroy, :move]

    def index
        @tg = TagGroup.all.order(:position)
        respond_to do |format|
            format.html
            format.js
        end
    end

    def new
        @tg = TagGroup.new
    end

    def create
        @tg = TagGroup.new(tg_params)
        respond_to do |format|
          if @tg.save
            format.html { redirect_to admin_tag_groups_path, notice: 'Tag Group was successfully created.' }
          else
            format.html { render :new }
          end
        end
    end

    def edit
    end
  
    def update
      respond_to do |format|
        @tg.attributes = tg_params
        if @tg.save
          format.html { redirect_to admin_tag_groups_path, notice: 'Tag Group was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
        @tg.destroy
        respond_to do |format|
          format.html { redirect_to admin_tag_groups_path, notice: 'Ad was successfully destroyed.' }
        end
    end

    def move
      @tg.move_to! params[:position]
      # render :nothing => true, :status => 200, :content_type => 'text/html'
      render body: nil
    end

    private
    def set_tg
        @tg = TagGroup.friendly.find(params[:id])
    end
    
    def tg_params
        params.require(:tag_group).permit(:name, :category_id)
    end
end