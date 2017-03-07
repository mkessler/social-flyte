FactoryGirl.define do
  factory :twitter_account do
    organization
    twitter_id 109068078
    token Rails.application.secrets.twitter_access_token
    secret Rails.application.secrets.twitter_access_token_secret
    screen_name 'mikaelkessler'
    image_url Faker::Avatar.image
  end
end
