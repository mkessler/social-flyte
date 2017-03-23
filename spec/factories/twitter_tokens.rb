FactoryGirl.define do
  factory :twitter_token do
    organization nil
    encrypted_token "MyString"
    encrypted_secret "MyString"
    encrypted_token_iv "MyString"
    encrypted_secret_iv "MyString"
    network_user_id "MyString"
    network_user_name "MyString"
    network_user_image_url "MyString"
  end
end
