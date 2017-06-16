class FacebookToken < ApplicationRecord
  belongs_to :user

  attr_encrypted :token, key: Rails.application.secrets.access_tokens_secret, encode: true, encode_iv: true, encode_salt: true

  validates :user_id, :encrypted_token, :encrypted_token_iv, presence: true
  validates :network_user_id, presence: true, uniqueness: { scope: :user_id }

  before_save :exchange_for_long_lived_token
  before_save :get_user_details

  def expired?
    DateTime.now.utc >= expires_at
  end

  private

  def exchange_for_long_lived_token
    # immediately get 60 day auth token
    oauth = Koala::Facebook::OAuth.new(
      Rails.application.secrets.facebook_app_id,
      Rails.application.secrets.facebook_app_secret
    )
    new_access_info = oauth.exchange_access_token_info(self.token)

    new_access_token = new_access_info['access_token']
    new_access_expires_at = DateTime.now + new_access_info['expires_in'].to_i.seconds

    self.token = new_access_token
    self.expires_at = new_access_expires_at
  end

  def get_user_details
    details = FacebookService.new(self.user).user_details
    self.network_user_name = details[:network_user_name]
    self.network_user_image_url = details[:network_user_image_url]
  end
end
