class Authentication < ApplicationRecord
  belongs_to :user

  def self.from_omniauth(user, params)
    get_long_lived_token(params[:oauth_token]) if params[:provider] == NETWORK_PROVIDERS[:facebook]

    where(provider: params[:provider]).
    where(uid: params[:uid]).
    first_or_initialize.tap do |authentication|
      authentication.user = user
      authentication.provider = params[:provider]
      authentication.uid = params[:uid]
      authentication.oauth_token = @long_lived_token || params[:oauth_token]
      authentication.oauth_expires_at = @long_lived_token_expires_at || DateTime.now.utc + params[:oauth_expires_at].to_i.seconds
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
    DateTime.now.utc >= oauth_expires_at rescue true
  end
end
