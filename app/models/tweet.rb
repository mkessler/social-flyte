class Tweet < ApplicationRecord
  belongs_to :post

  validates :post_id, :network_user_id, :network_user_name, :network_user_screen_name, :favorite_count, :retweet_count, :message, :posted_at, presence: true
  validates :network_tweet_id, presence: true, uniqueness: { scope: :post_id }

  scope :flagged, -> { where(flagged: true) }
end
