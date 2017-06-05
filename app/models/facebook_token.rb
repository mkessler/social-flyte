class FacebookToken < ApplicationRecord
  belongs_to :user

  attr_encrypted :token, key: Rails.application.secrets.access_tokens_secret, encode: true, encode_iv: true, encode_salt: true

  validates :user_id, :encrypted_token, :encrypted_token_iv, :expires_at, presence: true
  validates :network_user_id, presence: true, uniqueness: { scope: :user_id }

  after_create :get_user_details

  def expired?
    DateTime.now.utc >= expires_at
  end

  def renew_token
    # immediately get 60 day auth token
    oauth = Koala::Facebook::OAuth.new(
      Rails.application.secrets.facebook_app_id,
      Rails.application.secrets.facebook_app_secret
    )
    new_access_info = oauth.exchange_access_token_info self.token

    new_access_token = new_access_info['access_token']
    new_access_expires_at = DateTime.now + new_access_info['expires'].to_i.seconds

    self.update_attributes(
      token: new_access_token,
      expires_at: new_access_expires_at
    )
 end

  private

  def get_user_details
    FacebookService.new(self.user).update_user_details
  end
end
