FactoryGirl.define do
  factory :facebook_token do
    user
    token 'EAAYWqqyPLBQBAEnffxqvbW0tJ3s7aJUPSDCRwKJPqxC0WdxD6NDnNy1JG9lla92VxZBUqNXwqCKDXeZBWBDYJwpnV4REeYnO126WVsRd4l7n7NePQOxcRmOE5VKDYHHxckDZBv6n1470iHnvLBR5O5rEiFafP0ZD'
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
