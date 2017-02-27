FactoryGirl.define do
  factory :tweet do
    post
    network_tweet_id Faker::Number.number(10)
    network_user_id Faker::Number.number(10)
    network_user_name Faker::App.name
    favorites_count Faker::Number.number(3)
    retweet_count Faker::Number.number(3)
    message Faker::StarWars.quote
    hashtags "#test, #check"
    posted_at DateTime.now.utc
  end
end
