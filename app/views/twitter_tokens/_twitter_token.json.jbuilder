json.extract! twitter_token, :id, :organization_id, :network_user_name, :network_user_image_url, :created_at, :updated_at
json.url twitter_token_url(twitter_token, format: :json)
