FactoryGirl.define do
  factory :reaction do
    post
    network_user_id Faker::Number.number(10)
    network_user_link Faker::Internet.url
    network_user_name Faker::Name.name
    network_user_picture Faker::Avatar.image
    category ['LIKE', 'LOVE', 'ANGRY', 'WOW', 'SAD', 'HAHA'].sample
  end
end
