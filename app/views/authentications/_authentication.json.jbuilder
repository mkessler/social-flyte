json.extract! authentication, :id, :user_id, :network_id, :network_user_id, :token, :expires_at, :created_at, :updated_at
json.url authentication_url(authentication, format: :json)
