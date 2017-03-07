class AccessToken < ApplicationRecord
  belongs_to :network
  belongs_to :user

  attr_encrypted :token, key: Rails.application.secrets.access_tokens_secret, encode: true, encode_iv: true, encode_salt: true
  attr_encrypted :secret, key: Rails.application.secrets.access_tokens_secret, encode: true, encode_iv: true, encode_salt: true

  validates :user_id, :network_user_id, :encrypted_token, presence: true
  validates :network_id, presence: true, uniqueness: { scope: :user_id }

  def expired?
    DateTime.now.utc >= expires_at rescue true
  end
end
