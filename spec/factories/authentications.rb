FactoryGirl.define do
  factory :authentication do
    user
    provider NETWORK_PROVIDERS.values.sample
    uid Faker::Number.number(7)
    oauth_token Faker::Number.number(18)
    oauth_expires_at DateTime.now.utc + 1000000
  end
end
