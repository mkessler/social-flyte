FactoryGirl.define do
  factory :invitation do
    organization
    sender_id 1
    recipient_id nil
    email Faker::Internet.email
    token nil
    accepted false
  end
end
