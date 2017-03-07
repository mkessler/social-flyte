class AccessTokensController < ApplicationController
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def authorization
    current_user.access_tokens.create!(
      network: Network.find_by_slug(params[:network]),
      network_user_id: auth_hash.uid,
      token: auth_hash.credentials.token,
      secret: auth_hash.credentials.secret
    )

    flash[:notice] = "#{params[:network].titleize} authorized!"
    redirect_to root_url
  end

  protected

    def auth_hash
      request.env['omniauth.auth']
    end

  private

    def record_invalid
      flash[:error] = "There was an issue trying to authorize #{params[:network].titleize}, please try again."
      redirect_to root_url
    end
end
