class TwitterTokensController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_twitter_token, only: [:create_or_update, :update, :destroy]

  # GET /twitter_tokens/create_or_update
  # GET /twitter_tokens/create_or_update.json
  def create_or_update
    if @twitter_token.present?
      update
    else
      create
    end
  end

  # POST /twitter_tokens
  # POST /twitter_tokens.json
  def create
    @twitter_token = @organization.twitter_tokens.new(twitter_token_params)

    respond_to do |format|
      if @twitter_token.save
        format.html { redirect_to organization_accounts_path(@organization), notice: 'Twitter account connected!' }
        format.json { render :show, status: :created, location: @twitter_token }
      else
        format.html { redirect_to organization_accounts_path(@organization), error: 'Twitter account failed to connect.' }
        format.json { render json: @twitter_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /twitter_tokens/1
  # PATCH/PUT /twitter_tokens/1.json
  def update
    respond_to do |format|
      if @twitter_token.update(twitter_token_params)
        format.html { redirect_to organization_accounts_path(@organization), notice: 'Twitter account was successfully updated.' }
        format.json { render :show, status: :ok, location: @twitter_token }
      else
        format.html { redirect_to organization_accounts_path(@organization), error: 'Twitter account failed to update.' }
        format.json { render json: @twitter_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /twitter_tokens/1
  # DELETE /twitter_tokens/1.json
  def destroy
    @twitter_token.destroy
    respond_to do |format|
      format.html { redirect_to organization_accounts_path(@organization), notice: 'Twitter account removed!' }
      format.json { head :no_content }
    end
  end

  protected
    # Twitter oAuth information
    def auth_hash
      request.env['omniauth.auth']
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_twitter_token
      @twitter_token = @organization.twitter_tokens.find_by_network_user_id(auth_hash.uid)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def twitter_token_params
      {
        token: auth_hash.credentials.token,
        secret: auth_hash.credentials.secret,
        network_user_id: auth_hash.uid,
        network_user_name: auth_hash.extra.raw_info.screen_name
      }
    end
end
