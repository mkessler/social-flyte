FactoryGirl.define do
  factory :authentication do
    user
    network_id [1,2,3].sample
    network_user_id Faker::Number.number(7)
    token Faker::Number.number(18)
    expires_at DateTime.now.utc + 1000000
  end
end
