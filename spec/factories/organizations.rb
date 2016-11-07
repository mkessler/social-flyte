FactoryGirl.define do
  factory :organization do
    name Faker::Company.name
    # slug Faker::Company.name.downcase
  end
end
