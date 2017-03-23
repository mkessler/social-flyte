class TwitterToken < ApplicationRecord
  belongs_to :organization

  attr_encrypted :token, key: Rails.application.secrets.access_tokens_secret, encode: true, encode_iv: true, encode_salt: true
  attr_encrypted :secret, key: Rails.application.secrets.access_tokens_secret, encode: true, encode_iv: true, encode_salt: true

  validates :organization_id, :encrypted_token, :encrypted_token_iv, :network_user_name, :network_user_image_url, presence: true
  validates :network_user_id, presence: true, uniqueness: { scope: :organization_id }

  def screen_name
    "@#{network_user_name}" if network_user_name.present?
  end
end
