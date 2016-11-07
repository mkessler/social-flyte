FactoryGirl.define do
  factory :post do
    campaign
    network_id 1
    network_post_id Faker::Number.number(10)
    network_parent_id Faker::Number.number(10)
  end
end
