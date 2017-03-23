FactoryGirl.define do
  factory :facebook_token do
    user
    encrypted_token "H0rdTxbeesAIjGU2GCYttf4levpgTwMIGb6lcZVhr2NwWm6e+gwpLW9VvU9h\n5SEpBhseo4Gdw8LzANyynkVIZt15bzuibDlGxxHLGzMJJxPU7Ue+q13I/rn2\ntFrJpS/HTfRHJ4P+ghQHWSAKxmyZm+BaeJWguF1V1JByNx3477pBWyyOOcQ7\nChDO8o5/msbawObZnhS15QuiS03GWUJILsr4n3/WP9lL4QJiJn852f0igtzx\nUEBwbdS619LLUt66yfAREpY9QG+JL/1I4fEmRWrVcDk=\n"
    encrypted_token_iv "JCjQ8/u5pt+zcVt4\n"
    network_user_id Faker::Number.number(10)
    network_user_name Faker::Name.name
    network_user_image_url Faker::Avatar.image
    expires_at Time.now + 1.day
  end
end
