FactoryGirl.define do
  factory :invitation do
    organization nil
    sender_id 1
    recipient_id 1
    email "MyString"
    first_name "MyString"
    last_name "MyString"
    token "MyString"
    accepted false
  end
end
