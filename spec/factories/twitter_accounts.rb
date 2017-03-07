FactoryGirl.define do
  factory :twitter_account do
    organization
    twitter_id Faker::Number.number(10)
    encrypted_token Faker::Number.number(10)
    encrypted_secret Faker::Number.number(10)
    encrypted_token_iv Faker::Number.number(10)
    encrypted_secret_iv Faker::Number.number(10)
    screen_name Faker::Twitter.user.screen_name
    image_url Faker::Avatar.image
  end
end
