FactoryGirl.define do
  factory :facebook_token do
    user
    token 'EAAYWqqyPLBQBAEWIPYZAWuQ6uYSjoBEzqc1o24fX9QbWAQinXhggdLjWZCBAJg187qZBYD26Qh37lrYJ6L6Mc2TcBZC9GNVRO2DhHguyU7ec8adBXjl06wlyDZBHQwsqZCqIuE8euDlg2U0cbmnS0kiRZAxaJG7zqcZD'
    network_user_id '10106147434913000'
    expires_at Time.now + 1.day

    after(:build) { |facebook_token|
      class << facebook_token
        def get_user_details; true; end
      end
    }

    trait :with_before_save_callback do
      after(:build) { |user|
        class << user
          def get_user_details; super; end
        end
      }
    end
  end
end
