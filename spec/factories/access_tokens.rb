FactoryGirl.define do
  factory :access_token do
    network network
    user user
    network_user_id '12345'
    token 'abcd1234'
    secret 'secret_string'
    expires_at Time.now + 1.day
  end
end
