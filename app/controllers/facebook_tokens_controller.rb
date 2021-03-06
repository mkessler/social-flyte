class FacebookTokensController < ApplicationController
  before_action :authenticate_user!
  before_action :set_facebook_token, only: [:create_or_update, :update, :destroy]

  # POST /facebook_tokens/create_or_update
  # POST /facebook_tokens/create_or_update.json
  def create_or_update
    if @facebook_token.present?
      update
    else
      create
    end
  end

  # POST /facebook_tokens
  # POST /facebook_tokens.json
  def create
    @facebook_token = current_user.build_facebook_token(facebook_token_params)
    respond_to do |format|
      if @facebook_token.save
        format.json { render :show, status: :created, location: @facebook_token }
      else
        format.json { render json: @facebook_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facebook_tokens/1
  # PATCH/PUT /facebook_tokens/1.json
  def update
    respond_to do |format|
      if @facebook_token.update(facebook_token_params)
        format.json { render :show, status: :ok, location: @facebook_token }
      else
        format.json { render json: @facebook_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facebook_tokens/1
  # DELETE /facebook_tokens/1.json
  def destroy
    @facebook_token.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facebook_token
      @facebook_token = current_user.facebook_token
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facebook_token_params
      params.require(:facebook_token).permit(:token, :network_user_id, :network_user_name, :network_user_image_url)
    end
end
