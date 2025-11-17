class Admin::RssFeedsController < Admin::ApplicationController
    before_action :set_feed, only: [:destroy]
    def index
        @force = RssFeed.promote
        @blacklist = RssFeed.blacklist
        @feed = RssFeed.new
    end

    def create
        @feed = RssFeed.new(feed_params)
        respond_to do |format|
            if @feed.save
                format.html { redirect_to admin_rss_feeds_path, notice: 'Ad was successfully created.' }
            else
                format.html { render :new }
            end
        end
    end

    def destroy
        @feed.destroy
        respond_to do |format|
          format.html { redirect_to admin_rss_feeds_path, notice: 'Entry was successfully destroyed.' }
        end
    end

    private
  
    def set_feed
        @feed = RssFeed.find(params[:id])
    end

    def feed_params
        params.require(:rss_feed).permit(:locale, :article_id, :action)
    end
end
