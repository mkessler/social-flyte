FactoryGirl.define do
  factory :facebook_token do
    user nil
    encrypted_token "MyString"
    encrypted_token_iv "MyString"
    network_user_id "MyString"
    network_user_name "MyString"
    network_user_image_url "MyString"
    expires_at "2017-03-22 02:29:44"
  end
end
