class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_campaign
  before_action :set_post, only: [:show, :destroy]

  # GET organizations/friendly_id/campaigns/friendly_id/posts
  # GET organizations/friendly_id/campaigns/friendly_id/posts.json
  def index
    @posts = @campaign.posts
  end

  # GET organizations/friendly_id/campaigns/friendly_id/posts
  # GET organizations/friendly_id/campaigns/friendly_id/posts.json
  def show
  end

  # GET organizations/friendly_id/campaigns/friendly_id/posts/new
  def new
    @post = @campaign.posts.new
  end

  # POST organizations/friendly_id/campaigns/friendly_id/posts
  # POST organizations/friendly_id/campaigns/friendly_id/posts.json
  def create
    @post = @campaign.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to organization_campaign_post_url(@organization, @campaign, @post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE organizations/friendly_id/campaigns/friendly_id/posts
  # DELETE organizations/friendly_id/campaigns/friendly_id/posts.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to organization_campaign_posts_url(@organization, @campaign), notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = @campaign.posts.find(params[:id])
    end

    def set_campaign
      @campaign = @organization.campaigns.friendly.find(params[:campaign_id])
    end

    def set_organization
      @organization = current_user.organizations.friendly.find(params[:organization_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:network_id, :network_post_id, :network_parent_id)
    end
end
