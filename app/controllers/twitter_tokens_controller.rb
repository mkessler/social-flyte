class TwitterTokensController < ApplicationController
  before_action :set_twitter_token, only: [:show, :edit, :update, :destroy]

  # GET /twitter_tokens
  # GET /twitter_tokens.json
  def index
    @twitter_tokens = TwitterToken.all
  end

  # GET /twitter_tokens/1
  # GET /twitter_tokens/1.json
  def show
  end

  # GET /twitter_tokens/new
  def new
    @twitter_token = TwitterToken.new
  end

  # GET /twitter_tokens/1/edit
  def edit
  end

  # POST /twitter_tokens
  # POST /twitter_tokens.json
  def create
    @twitter_token = TwitterToken.new(twitter_token_params)

    respond_to do |format|
      if @twitter_token.save
        format.html { redirect_to @twitter_token, notice: 'Twitter token was successfully created.' }
        format.json { render :show, status: :created, location: @twitter_token }
      else
        format.html { render :new }
        format.json { render json: @twitter_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /twitter_tokens/1
  # PATCH/PUT /twitter_tokens/1.json
  def update
    respond_to do |format|
      if @twitter_token.update(twitter_token_params)
        format.html { redirect_to @twitter_token, notice: 'Twitter token was successfully updated.' }
        format.json { render :show, status: :ok, location: @twitter_token }
      else
        format.html { render :edit }
        format.json { render json: @twitter_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /twitter_tokens/1
  # DELETE /twitter_tokens/1.json
  def destroy
    @twitter_token.destroy
    respond_to do |format|
      format.html { redirect_to twitter_tokens_url, notice: 'Twitter token was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_twitter_token
      @twitter_token = TwitterToken.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def twitter_token_params
      params.require(:twitter_token).permit(:organization_id, :encrypted_token, :encrypted_secret, :encrypted_token_iv, :encrypted_secret_iv, :network_user_id, :network_user_name, :network_user_image_url)
    end
end
