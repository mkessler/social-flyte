FactoryGirl.define do
  factory :comment do
    post
    network_comment_id Faker::Number.number(10)
    network_user_id Faker::Number.number(10)
    network_user_name Faker::Name.name
    like_count Faker::Number.number(3)
    message Faker::StarWars.quote
    posted_at DateTime.now.utc
  end
end
