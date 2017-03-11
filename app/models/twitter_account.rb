class TwitterAccount < ApplicationRecord
  belongs_to :organization

  attr_encrypted :token, key: Rails.application.secrets.access_tokens_secret, encode: true, encode_iv: true, encode_salt: true
  attr_encrypted :secret, key: Rails.application.secrets.access_tokens_secret, encode: true, encode_iv: true, encode_salt: true

  validates :organization_id, :encrypted_token, :encrypted_token_iv, :encrypted_secret, :encrypted_secret_iv, :screen_name, :image_url, presence: true
  validates :twitter_id, presence: true, uniqueness: { scope: :organization_id }

  def screen_name
    "@#{self[:screen_name]}" if self[:screen_name].present?
  end
end
