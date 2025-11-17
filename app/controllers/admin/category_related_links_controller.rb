class Admin::CategoryRelatedLinksController < Admin::ApplicationController
    before_action :set_tag, only: [:show, :edit, :update, :destroy]
    def create
        @link = CategoryRelatedLink.new(link_params)
        respond_to do |format|
            if @link.save
            format.html { redirect_to @link.category, notice: 'Comment was successfully created.' }
            format.js   { }
            else
            format.html { render :new }
            format.json { render json:@link.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @id = @link.id
        @link.destroy
        respond_to do |format|
          format.html { redirect_to admin_tags_url, notice: 'Tag was successfully destroyed.' }
          format.js   { }
          # format.json { head :no_content }
        end
    end
    private
    def link_params
        params.require(:category_related_link).permit(:title, :link, :category_id)
    end
    def set_tag
        @link = CategoryRelatedLink.find(params[:id])
    end
end