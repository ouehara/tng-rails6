class Admin::VideosController < Admin::ApplicationController
    before_action :set_video, only: [:show, :edit, :update, :destroy, :move]

    def index
        @videos = Video.all.order(:position)
        respond_to do |format|
            format.html
            format.js
        end
    end

    def new
        @video = Video.new
    end
    
    def create
        @video = Video.new(video_params)
        @video.position = -1
        respond_to do |format|
            if @video.save
            Video.order(:position).each.with_index(0) do |item, index|
                item.update_column :position, index
            end   
            format.html { redirect_to admin_videos_path, notice: 'video was successfully created.' }
            else
            format.html { render :new }
            end
        end
    end
    
      
    def edit
    end

    def move
        @video.move_to! params[:position]
        # render :nothing => true, :status => 200, :content_type => 'text/html'
        render body: nil
    end
      
    def update
        respond_to do |format|
            @video.attributes = video_params
            if @video.save
            format.html { redirect_to admin_videos_path, notice: 'video was successfully updated.' }
            else
            format.html { render :edit }
            end
        end
    end

    def destroy
        @video.destroy
        respond_to do |format|
            format.html { redirect_to admin_videos_path, notice: 'video was successfully destroyed.' }
        end
    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
        @video = Video.find(params[:id])
    end

    def video_params
        params.require(:video).permit(:title, :link,  :banner, :user)
    end
end