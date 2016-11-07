FactoryGirl.define do
  factory :campaign do
    organization
    name Faker::Space.galaxy
  end
end
