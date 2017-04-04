FactoryGirl.define do
  factory :twitter_token do
    organization
    token Rails.application.secrets.twitter_access_token
    secret Rails.application.secrets.twitter_access_token_secret
    network_user_id 109068078
    network_user_name 'mikaelkessler'
  end
end
