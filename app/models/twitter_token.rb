class TwitterToken < ApplicationRecord
  belongs_to :organization

  attr_encrypted :token, key: Rails.application.secrets.access_tokens_secret, encode: true, encode_iv: true, encode_salt: true
  attr_encrypted :secret, key: Rails.application.secrets.access_tokens_secret, encode: true, encode_iv: true, encode_salt: true

  validates :organization_id, :encrypted_token, :encrypted_token_iv, :encrypted_secret, :encrypted_secret_iv, :network_user_name, :network_user_image_url, presence: true
  validates :network_user_id, presence: true, uniqueness: { scope: :organization_id }

  before_validation :set_network_user_image_url, on: [:create, :update]

  def network_user_name
    "@#{self[:network_user_name]}" if self[:network_user_name].present?
  end

  private

  def set_network_user_image_url
    self.network_user_image_url = "https://twitter.com/#{network_user_name}/profile_image?size=original"
  end
end
