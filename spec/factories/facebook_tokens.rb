FactoryGirl.define do
  factory :facebook_token do
    user
    token 'EAAYWqqyPLBQBAOfZAd9NGZBVr5wCRNwx2S8qGKn9ZCC4sisKD5jOGgN9tCqxoZC6E4RAoKRXLqMJU5fmu28tcIbQzZCGTEV0F01NYdsGnelZB7IyxCvZBQAD0aE7zPOji2vZBNiULZClpZC2QrfZB0s9c1SZB7sgZC3vcjJwbeAsbddfp3Dm6RR8TTJrBTAZBUvcIoEs0ZD'
    network_user_id '10106147434913000'
    expires_at Time.now + 1.day
  end
end
