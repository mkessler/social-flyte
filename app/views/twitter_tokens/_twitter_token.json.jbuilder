json.extract! twitter_token, :id, :organization_id, :encrypted_token, :encrypted_secret, :encrypted_token_iv, :encrypted_secret_iv, :network_user_id, :network_user_name, :network_user_image_url, :created_at, :updated_at
json.url twitter_token_url(twitter_token, format: :json)