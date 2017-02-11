class NetworkTokensController < ApplicationController
  before_action :authenticate_user!

  def set
    session["#{params[:network]}_token"] = params[:token]
    session["#{params[:network]}_token_expires_at"] = Time.now.utc + params[:expires_at].to_i.second

    respond_to do |format|
      if session["#{params[:network]}_token"].present? && session["#{params[:network]}_token_expires_at"].present?
        format.json { render json: {network_token: true}.to_json, status: :ok }
      else
        format.json { render json: {network_token: false}.to_json, status: :unprocessable_entity }
      end
    end
  end
end
