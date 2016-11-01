json.extract! authentication, :id, :user_id, :provider, :uid, :oauth_token, :oauth_expires_at, :created_at, :updated_at
json.url authentication_url(authentication, format: :json)
