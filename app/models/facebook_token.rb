class FacebookToken < ApplicationRecord
  belongs_to :user

  attr_encrypted :token, key: Rails.application.secrets.access_tokens_secret, encode: true, encode_iv: true, encode_salt: true

  validates :user_id, :encrypted_token, :encrypted_token_iv, :expires_at, presence: true
  validates :network_user_id, presence: true, uniqueness: { scope: :user_id }

  after_create :get_user_details

  def expired?
    DateTime.now.utc >= expires_at
  end

  private

  def get_user_details
    FacebookDetailsJob.perform_later(self.user)
  end
end
