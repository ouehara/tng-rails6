class RssFeedsController < ApplicationController
    def index
        redirect_to "https://#{ENV["TNG_S3_BUCKET"]}.s3-#{ENV["TNG_AWS_S3_REGION"]}.amazonaws.com/feed/#{params[:l]}.xml"
    end
end