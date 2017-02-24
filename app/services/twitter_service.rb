require 'twitter'

class TwitterService

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.twitter_consumer_key
      config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
      config.access_token        = Rails.application.secrets.twitter_access_token
      config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
    end
  end

  def fetch_user(id)
    @client.user(id)
  end

  def fetch_tweet(id)
    @client.status(id)
  end

  def fetch_mentions
    mentions = @client.mentions_timeline
    byebug
  end
end
