json.extract! facebook_token, :id, :user_id, :network_user_name, :network_user_image_url, :expires_at, :created_at, :updated_at
json.url facebook_token_url(facebook_token, format: :json)
