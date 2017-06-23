FactoryGirl.define do
  factory :post do
    campaign
    name Faker::Friends.quote
    network_id 1
    network_post_id Faker::Number.number(10)
    network_parent_id Faker::Number.number(10)
    sync_count Faker::Number.number(2)
    synced_at DateTime.now.utc
  end
end
