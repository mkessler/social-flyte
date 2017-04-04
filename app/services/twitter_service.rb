require 'twitter'

class TwitterService
  def initialize(post)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.twitter_consumer_key
      config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
      config.access_token        = post.twitter_token.token
      config.access_token_secret = post.twitter_token.secret
    end
    @post = post
  end

  def sync
    if @post.network == Network.twitter
      update_token
      build_mentions
      @post.reload
      @post.update_sync_status
    else
      false
    end
  end

  private

  def build_mentions
    @client.mentions_timeline.each do |mention|
      @post.tweets.find_or_create_by(network_tweet_id: mention.id) do |tweet|
        tweet.network_user_id = mention.user.id
        tweet.network_user_name = mention.user.name
        tweet.network_user_screen_name = mention.user.screen_name
        tweet.favorite_count = mention.favorite_count
        tweet.retweet_count = mention.retweet_count
        tweet.message = mention.text
        tweet.hashtags = mention.hashtags.map(&:text)
        tweet.posted_at = mention.created_at
      end
    end
  end

  def update_token
    account = @client.user(@post.twitter_token.network_user_id.to_i)
    @post.twitter_token.update_attributes(
      network_user_name: account.screen_name,
    )
  end
end
