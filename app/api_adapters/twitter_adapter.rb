require 'twitter'

# @author Shiro Fukuda
# @attr_reader :client Twitter::REST::Client object
# @example Get Pokemon tweets from 12341112 tweet to 12341234 tweet with limit count 20.
# client = TwitterAdapter.new
# client.search("Pokemon", count: 20, result_type: 'recent', max_id: "12341234", since_id: "12341112")
class TwitterAdapter

  # Set getter
  attr_reader :client

  # Initialize TwitterAdapter client with consumer key and consumer secret
  # This class does not require OAuth2 and can retrieve only public tweets
  # @option opts [String] :consumer_key The client key for Twitter App, devault
  # @option opts [String] :consumer_secret The client secret for Twitter App
  # @example Initialize TwitterAdapter with consumer key and consumer secret.
  # TwitterAdapter.new(client_key: ENV['TNG_TWITTER_CONSUMER_KEY'], consumer_secret: ENV['TNG_TWITTER_CONSUMER_SECRET'])
  # Default options
  # consumer_key: ENV['TNG_TWITTER_CONSUMER_KEY']
  # consumer_secret: ENV['TNG_TWITTER_CONSUMER_SECRET']
  def initialize(opts={})
    # Define default options
    default_opts = {
      consumer_key: ENV['TNG_TWITTER_CONSUMER_KEY'],
      consumer_secret: ENV['TNG_TWITTER_CONSUMER_SECRET']
    }

    # Merge default options
    opts = default_opts.merge(opts)

    # Initialize Twitter Client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = opts[:consumer_key]
      config.consumer_secret = opts[:consumer_secret]
    end
  end

  # Search tweets by options
  # @option opts [Integer] :count tweets count limit. This could be used for pagination.
  # @option opts [String] :max_id last tweet id. This could be used for pagination.
  # @option opts [String] :since_id first tweet id. This could be used for pagination.
  # @option opts [String] :result_type
  # @see https://dev.twitter.com/rest/public/search
  # Default options
  #   hashtags: nil
  #   count: 100
  #   max_id: nil
  #   since_id: nil
  #   result_type: 'recent'
  def search(query, opts={})
    # Define defaults
    default_options = {
      count: 100
    }

    # Merge defaults
    opts = default_options.merge(opts)

    # Send request and get response
    @client.search(query, opts).take(opts[:count])
  end

end
