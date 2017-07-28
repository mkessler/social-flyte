FactoryGirl.define do
  factory :share do
    post
    network_user_id Faker::Number.number(10)
    network_user_name Faker::Name.name
    network_share_id Faker::Number.number(10)
  end
end
