class Authentication < ApplicationRecord
  belongs_to :user

  def self.from_omniauth(user, params)
    get_long_lived_token(params[:token]) if params[:provider] == NETWORK_PROVIDERS[:facebook]

    where(provider: params[:provider]).
    where(provider_user_id: params[:provider_user_id]).
    first_or_initialize.tap do |authentication|
      authentication.user = user
      authentication.provider = params[:provider]
      authentication.provider_user_id = params[:provider_user_id]
      authentication.token = @long_lived_token || params[:token]
      authentication.expires_at = @long_lived_token_expires_at || DateTime.now.utc + params[:expires_at].to_i.seconds
      authentication.save!
    end
  end

  def self.get_long_lived_token(access_token)
    oauth = Koala::Facebook::OAuth.new(
      Rails.application.secrets.facebook_app_id,
      Rails.application.secrets.facebook_app_secret
    )
    access_token_info = oauth.exchange_access_token_info(access_token)

    @long_lived_token = access_token_info["access_token"]
    @long_lived_token_expires_at = DateTime.now.utc + access_token_info["expires"].to_i.seconds
  end

  def expired?
    DateTime.now.utc >= expires_at rescue true
  end
end
